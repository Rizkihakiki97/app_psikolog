import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/user_firebase_model.dart';
import 'package:app_psikolog/services/firebase.dart';
import 'package:app_psikolog/model/user_model.dart';
import 'package:app_psikolog/view/login_mindcare.dart';
import 'package:app_psikolog/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_psikolog/preferences/preferences_handler.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  UserFirebaseModel user = UserFirebaseModel();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3D64),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCEAFF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.psychology_outlined,
                            color: Color(0xFF3D8BFF),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "MindCare",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your mental wellness companion",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // FORM
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Create Account", style: TextStyle(fontSize: 22)),
                      const SizedBox(height: 5),
                      Text(
                        "Sign up to get started",
                        style: TextStyle(fontSize: 19, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 30),

                      // FULL NAME
                      const Text("Full Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 14)),
                      const SizedBox(height: 8),
                      TextfieldCont(
                        controller: usernameController,
                        hintText: "Enter your name",
                      ),

                      const SizedBox(height: 15),

                      // EMAIL
                      const Text("Email",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 14)),
                      const SizedBox(height: 8),
                      TextfieldCont(
                        controller: emailController,
                        hintText: "Enter your email",
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty";
                          } else if (!value.contains("@")) {
                            return "Invalid email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // PASSWORD
                      const Text("Password",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 14)),
                      const SizedBox(height: 8),
                      TextfieldCont(
                        controller: passwordController,
                        hintText: "Enter your password",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password cannot be empty";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                                color: Color(0xFF3D8BFF), fontSize: 14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // SIGN UP BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D8BFF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              UserFirebaseModel? newUser =
                                  await FirebaseService().registerUser(
                                name: usernameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                role: "Psikolog",
                              );

                              if (newUser != null) {
                                // 🔥 SIMPAN USER KE SharedPreferences
                                await PreferenceHandler.saveUserData(
                                  uid: newUser.uid ?? "",
                                  name: newUser.username ?? "",
                                  email: newUser.email ?? "",
                                );

                                // 🔥 SIMPAN STATUS LOGIN
                                await PreferenceHandler.saveLogin(true);

                                Fluttertoast.showToast(
                                  msg: "Register Success!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreenMindcare()),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ALREADY HAVE ACCOUNT
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreenMindcare()),
                              );
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Color(0xFF3D8BFF),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
