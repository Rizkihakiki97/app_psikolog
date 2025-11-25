import 'package:app_psikolog/database/db_helper.dart';
import 'package:app_psikolog/model/user_firebase_model.dart';
import 'package:app_psikolog/services/firebase.dart';
import 'package:app_psikolog/model/user_model.dart';
import 'package:app_psikolog/view/login_mindcare.dart';
import 'package:app_psikolog/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      backgroundColor: Color(0xFF1A3D64),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFDCEAFF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.psychology_outlined,
                            color: Color(0xFF3D8BFF),
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MindCare",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your mental wellness companion",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // Form
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                decoration: BoxDecoration(
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
                      Text("Create Account", style: TextStyle(fontSize: 22)),
                      SizedBox(height: 5),
                      Text(
                        "Sign up to get started",
                        style: TextStyle(fontSize: 19, color: Colors.grey[800]),
                      ),
                      SizedBox(height: 30),
                      // Full Name
                      Text("Full Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 14)),
                      SizedBox(height: 8),
                      TextfieldCont(
                        controller: usernameController,
                        hintText: "Enter your name",
                      ),
                      SizedBox(height: 15),
                      // Email
                      Text("Email",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 14)),
                      SizedBox(height: 8),
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
                      SizedBox(height: 18),
                      // Password
                      Text("Password",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 14)),
                      SizedBox(height: 8),
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
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                                color: Color(0xFF3D8BFF), fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3D8BFF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                          ),
                          onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                UserFirebaseModel? newUser = await FirebaseService().registerUser(
                                  name: usernameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  role: "Psikolog",
                                );

                                if (newUser != null) {
                                  // Misalnya simpan ke lokal jika perlu
                                  print("User baru: ${newUser.uid}, ${newUser.username}");

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreenMindcare()),
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
                      SizedBox(height: 30),
                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginScreenMindcare()),
                              );
                            },
                            child: Text(
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
