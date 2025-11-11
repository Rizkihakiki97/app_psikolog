import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/user_model.dart';
import 'package:app_psikolog/preferences/preferences_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 🔹 Load data user dari database
  Future<void> _loadUserData() async {
    final id = await PreferenceHandler.getUserId();
    if (id != null) {
      final user = await DbHelper.getUserById(id);
      if (user != null) {
        setState(() {
          userId = user.id;
          nameC.text = user.name;
          emailC.text = user.email;
          phoneC.text = user.phone ?? '';
          bioC.text = user.bio ?? '';
        });
      }
    }
  }

  // Simpan (Tambah/Edit)
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      if (userId == null) return;

      // 🔹 Ambil data lama biar field lain tidak kehapus
      final oldUser = await DbHelper.getUserById(userId!);
      if (oldUser == null) return;

      final updatedUser = UserModel(
        id: oldUser.id,
        name: nameC.text,
        email: emailC.text,
        phone: phoneC.text,
        bio: bioC.text,
        lisensi: oldUser.lisensi,
        foto: oldUser.foto,
        password: oldUser.password, // ⚠️ ambil password lama
        role: oldUser.role, // kalau ada role
      );

      await DbHelper.updateUser(updatedUser);

      // 🔹 update SharedPreferences biar email baru tersimpan

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      Navigator.pop(context, true); // kirim sinyal berhasil
    }
  }

  // Hapus profil
  Future<void> _deleteProfile() async {
    if (userId != null) {
      await DbHelper.deleteUser(userId!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile deleted successfully!")),
      );
      Navigator.pop(context);
    }
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
          if (userId != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteProfile,
              tooltip: "Delete Profile",
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
                      backgroundImage: AssetImage(
                        'assets/image/gambar/psikolog.png',
                      ),
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

              // Form Field
              _buildTextField("Full Name", nameC, Icons.person_outline),
              _buildTextField(
                "Email",
                emailC,
                Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                "Phone Number",
                phoneC,
                Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                "Bio / Description",
                bioC,
                Icons.info_outline,
                maxLines: 3,
              ),

              const SizedBox(height: 30),

              // Tombol Save
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save_outlined, color: Colors.white),
                  label: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16, color: Colors.white),
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

  // Widget input field
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF569ad1)),
          ),
        ),
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
      ),
    );
  }
}
