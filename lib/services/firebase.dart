import 'package:app_psikolog/model/user_firebase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===================================================
  // REGISTER USER
  // ===================================================
 Future<UserFirebaseModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      // Simpan data di Firestore
      await _firestore.collection("users").doc(uid).set({
        "uid": uid,
        "username": name,         // sesuaikan dengan nama field model
        "email": email,
        "role": role,
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      });

      // Buat model dari map
      UserFirebaseModel userModel = UserFirebaseModel(
        uid: uid,
        username: name,
        email: email,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      Fluttertoast.showToast(
        msg: "Registrasi Berhasil!",
        gravity: ToastGravity.BOTTOM,
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: "Error Registrasi: ${e.code} - ${e.message}",
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error Registrasi: $e",
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    }
  }

Future<UserFirebaseModel?> loginUser({
  required String email,
  required String password,
}) async {
  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

    if (userDoc.exists) {
      final userModel = UserFirebaseModel.fromMap(userDoc.data()!);
      Fluttertoast.showToast(
        msg: "Login Berhasil!",
        gravity: ToastGravity.BOTTOM,
      );
      return userModel;
    } else {
      Fluttertoast.showToast(
        msg: "Data user tidak ditemukan di Firestore",
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Login Gagal: $e",
      gravity: ToastGravity.BOTTOM,
    );
    return null;
  }
}

}

  // Future<void> logoutUser() async {
  //   await _auth.signOut();
  //   Fluttertoast.showToast(
  //     msg: "Berhasil Logout!",
  //     gravity: ToastGravity.BOTTOM,
  //   );
  // }

//   // ===================================================
//   // GET USER BY UID
//   // ===================================================
//   Future<DocumentSnapshot<Map<String, dynamic>>?> getUserById(
//       String uid) async {
//     try {
//       return await _firestore.collection("users").doc(uid).get();
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Gagal mengambil data user: $e",
//           gravity: ToastGravity.BOTTOM);
//       return null;
//     }
//   }

//   // ===================================================
//   // GET ALL USERS
//   // ===================================================
//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
//       getAllUsers() async {
//     try {
//       var result = await _firestore.collection("users").get();
//       return result.docs;
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Gagal mengambil semua user: $e",
//           gravity: ToastGravity.BOTTOM);
//       return null;
//     }
//   }

//   // ===================================================
//   // UPDATE USER
//   // ===================================================
//   Future<bool> updateUser({
//     required String uid,
//     required Map<String, dynamic> data,
//   }) async {
//     try {
//       await _firestore.collection("users").doc(uid).update(data);

//       Fluttertoast.showToast(
//         msg: "Update User Berhasil!",
//         gravity: ToastGravity.BOTTOM,
//       );

//       return true;
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Gagal Update User: $e",
//         gravity: ToastGravity.BOTTOM,
//       );
//       return false;
//     }
//   }

//   // ===================================================
//   // DELETE USER
//   // ===================================================
//   Future<bool> deleteUser(String uid) async {
//     try {
//       await _firestore.collection("users").doc(uid).delete();

//       Fluttertoast.showToast(
//         msg: "User Berhasil Dihapus!",
//         gravity: ToastGravity.BOTTOM,
//       );

//       return true;
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: "Gagal Menghapus User: $e",
//         gravity: ToastGravity.BOTTOM,
//       );
//       return false;
//     }
//   }
// }
