import 'dart:io';
import 'package:app_psikolog/preferences/preferences_handler.dart';
import 'package:app_psikolog/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController bioC = TextEditingController();

  String? uid;
  String? profileUrl;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // ===================================================================
  // LOAD USER FIRESTORE
  // ===================================================================
  Future<void> _loadUser() async {
    uid = await PreferenceHandler.getUserId();
    if (uid == null) return;

    final user = await FirebaseService().getUserByUid(uid!);

    if (user != null) {
      setState(() {
        nameC.text = user.username ?? "";
        emailC.text = user.email ?? "";
        phoneC.text = user.phone ?? "";
        bioC.text = user.bio ?? "";
        profileUrl = user.photo;
      });
    }
  }

  // ===================================================================
  // PILIH FOTO DARI GALLERY / CAMERA
  // ===================================================================
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() => imageFile = File(picked.path));
      await _uploadImage();
    }
  }

  // ===================================================================
  // UPLOAD FOTO KE FIREBASE STORAGE
  // ===================================================================
  Future<void> _uploadImage() async {
    if (imageFile == null || uid == null) return;

    final storageRef =
        FirebaseStorage.instance.ref().child("profile_photos/$uid.jpg");

    await storageRef.putFile(imageFile!);

    final downloadUrl = await storageRef.getDownloadURL();

    setState(() => profileUrl = downloadUrl);

    // Simpan ke Firestore
    await FirebaseService().updateUser(
      uid: uid!,
      data: {"photoUrl": downloadUrl},
    );
  }

  // ===================================================================
  // SAVE PROFILE FIX
  // ===================================================================
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (uid == null) return;

    final updateData = {
      "username": nameC.text,
      "phone": phoneC.text,
      "bio": bioC.text,
      "photoUrl": profileUrl,
      "updatedAt": DateTime.now().toIso8601String(),
    };

    bool success =
        await FirebaseService().updateUser(uid: uid!, data: updateData);

    if (success) {
      await PreferenceHandler.saveUserData(
        uid: uid!,
        name: nameC.text,
        email: emailC.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      Navigator.pop(context);
    }
  }

  // ===================================================================
  // DELETE PROFILE
  // ===================================================================
  Future<void> _deleteProfile() async {
    if (uid == null) return;

    await FirebaseService().deleteUser(uid!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile deleted successfully!")),
    );

    Navigator.pop(context);
  }

  // ===================================================================
  // UI
  // ===================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FA),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF569ad1),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _deleteProfile,
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // =========================
              // AVATAR FOTO
              // =========================
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : (profileUrl != null
                              ? NetworkImage(profileUrl!)
                              : const AssetImage(
                                      'assets/images/gambar/psikolog.png')
                                  as ImageProvider),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF569ad1),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildTextField("Full Name", nameC, Icons.person_outline),
              _buildTextField("Email", emailC, Icons.email_outlined,
                  enabled: false),
              _buildTextField("Phone Number", phoneC, Icons.phone_outlined),
              _buildTextField("Bio / Description", bioC, Icons.info_outline,
                  maxLines: 3),

              const SizedBox(height: 25),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF569ad1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================================================================
  // FIELD BUILDER
  // ===================================================================
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF569ad1)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
