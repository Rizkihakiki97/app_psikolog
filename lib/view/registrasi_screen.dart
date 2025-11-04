import 'package:app_psikolog/view/bottom_navbar.dart';
import 'package:app_psikolog/view/login_screen_mindcare.dart';
import 'package:app_psikolog/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
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
                              "Mindcare",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your mental wellness companion",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
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
                        style: TextStyle(
                          fontSize: 19,
                          color: const Color.fromARGB(255, 85, 83, 83),
                        ),
                      ),
                      SizedBox(height: 30),

                      Text(
                        "Full Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextfieldCont(
                        controller: usernameController,
                        hintText: "Enter your name",
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
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

                      const SizedBox(height: 18),

                      const Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
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
                            return "Password must br at least 6 characters";
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
                              color: Color(0xFF3D8BFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D8BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            shadowColor: Colors.black.withOpacity(0.2),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomNavbar(),
                                ),
                              );
                              Fluttertoast.showToast(
                                msg: "Login registration",
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              "Or continue with",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Fluttertoast.showToast(
                              msg: "Google Sign In clicked",
                            );
                          },

                          // icon: Image.asset(
                          //   "assets/images/google_satu.png",
                          //   height: 20,
                          //   width: ,
                          // ),

                          // KOMENT
                          label: const Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 35),

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
                                  builder: (context) => LoginScreenMindcare(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF3D8BFF),
                                fontWeight: FontWeight.bold,
                              ),
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
