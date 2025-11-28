import 'package:app_psikolog/model/user_firebase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===================================================
  // REGISTER USER
  // ===================================================
  static Future<UserFirebaseModel?> registerUser({
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

      await _firestore.collection("users").doc(uid).set({
        "uid": uid,
        "username": name,
        "email": email,
        "role": role,
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      });

      UserFirebaseModel userModel = UserFirebaseModel(
        uid: uid,
        username: name,
        email: email,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      Fluttertoast.showToast(msg: "Registrasi Berhasil!");

      return userModel;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Error Registrasi: ${e.code}");
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Registrasi: $e");
      return null;
    }
  }

  // ===================================================
  // LOGIN USER
  // ===================================================
  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      String uid = credential.user!.uid;

      DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(uid).get();

      if (snapshot.exists) {
        Fluttertoast.showToast(msg: "Login Berhasil!");
        return UserFirebaseModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }

      Fluttertoast.showToast(msg: "Data user tidak ditemukan di Firestore");
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Login Gagal: $e");
      return null;
    }
  }

  static Future<UserFirebaseModel?> getProfile() async {
  try {
    // Ambil user yang sedang login
    User? user = _auth.currentUser;

    if (user == null) {
      Fluttertoast.showToast(msg: "Tidak ada user yang login");
      return null;
    }

    String uid = user.uid;

    // Ambil data dari Firestore
    DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(uid).get();

    if (snapshot.exists) {
      return UserFirebaseModel.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      Fluttertoast.showToast(msg: "Data user tidak ditemukan di Firestore");
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Gagal mendapatkan profil: $e");
    return null;
  }
  }


  // ===================================================
  // GET USER BY UID
  // ===================================================
  Future<UserFirebaseModel?> getUserByUid(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(uid).get();
      if (snapshot.exists) {
        return UserFirebaseModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal mengambil user: $e");
      return null;
    }
  }

  // ===================================================
  // UPDATE USER
  // ===================================================
  Future<bool> updateUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection("users").doc(uid).update(data);

      Fluttertoast.showToast(msg: "Profile Updated!");

      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal Update User: $e");
      return false;
    }
  }

  // ===================================================
  // DELETE USER
  // ===================================================
  Future<bool> deleteUser(String uid) async {
    try {
      await _firestore.collection("users").doc(uid).delete();
      await _auth.currentUser?.delete();
      Fluttertoast.showToast(msg: "User Berhasil Dihapus!");
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal Menghapus User: $e");
      return false;
    }
  }
}
