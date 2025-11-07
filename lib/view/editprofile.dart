import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/preferences/preferences_handler.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? fullname;

  // Simulasi data profil (nanti bisa diambil dari database)
  String name = "Rizky";
  String email = "muhammdhakiki97@email.com";
  String phone = "+62 896-1567-4013";
  String bio = "I’m a psychologist passionate about mental wellness.";

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController bioC = TextEditingController();

  @override
  void initState() {
    super.initState();
    PreferenceHandler.getUsername().then((value) {
      setState(() {
        fullname = value ?? 'Guest';
      });
    });
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = await PreferenceHandler.getUserId();
    if (userId != null) {
      final user = await AppDatabase.getUserById(userId);
      if (user != null) {
        setState(() {
          nameC.text = user.name;
          emailC.text = user.email;
          bioC.text = user.password;
        });
      }
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
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

              // Input Name
              _buildTextField(
                label: "Full Name",
                initialValue: name,
                icon: Icons.person_outline,
                onSaved: (value) => name = value!,
              ),

              // Input Email
              _buildTextField(
                label: "Email",
                initialValue: email,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value!,
              ),

              // Input Nomor Telepon
              _buildTextField(
                label: "Phone Number",
                initialValue: phone,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onSaved: (value) => phone = value!,
              ),

              // Input Bio
              _buildTextField(
                label: "Bio / Description",
                initialValue: bio,
                icon: Icons.info_outline,
                maxLines: 3,
                onSaved: (value) => bio = value!,
              ),

              const SizedBox(height: 30),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // final UserModel data = UserModel(id: id, nama: nama, role: role)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16),
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

  // Reusable Text Field Widget
  Widget _buildTextField({
    required String label,
    required String initialValue,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
