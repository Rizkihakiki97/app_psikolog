import 'package:app_psikolog/preferences/preferences_handler.dart';
import 'package:app_psikolog/services/firebase.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // ============================================================
  // Load Data User dari SharedPreferences + Firestore
  // ============================================================
  Future<void> _loadUser() async {
    uid = await PreferenceHandler.getUserId();

    if (uid == null) return;

    final user =
        await FirebaseService().getUserByUid(uid!);

    if (user != null) {
      setState(() {
        nameC.text = user.username ?? "";
        emailC.text = user.email ?? "";
      });
    }
  }

  // ============================================================
  // UPDATE PROFILE FIREBASE + SharedPreferences
  // ============================================================
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (uid == null) return;

    final updateData = {
      "username": nameC.text,
      "email": emailC.text,
      "phone": phoneC.text,
      "bio": bioC.text,
      "updatedAt": DateTime.now().toIso8601String(),
    };

    bool success = await FirebaseService().updateUser(
      uid: uid!,
      data: updateData,
    );

    if (success) {
      // Update local (SharedPreferences)
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

  // ============================================================
  // DELETE PROFILE (Firestore + Auth)
  // ============================================================
  Future<void> _deleteProfile() async {
    if (uid == null) return;

    await FirebaseService().deleteUser(uid!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile deleted successfully!")),
    );

    Navigator.pop(context);
  }

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
              // Avatar
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/gambar/psikolog.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
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
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildTextField("Full Name", nameC, Icons.person_outline),
              _buildTextField("Email", emailC, Icons.email_outlined),
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

  // ============================================================
  // FIELD BUILDER
  // ============================================================
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF569ad1)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF569ad1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Please enter $label" : null,
      ),
    );
  }
}
