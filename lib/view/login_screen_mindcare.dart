import 'package:app_psikolog/view/bottom_navbar.dart';
import 'package:app_psikolog/view/registrasi_screen.dart';
import 'package:app_psikolog/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class LoginScreenMindcare extends StatefulWidget {
  const LoginScreenMindcare({super.key});

  @override
  State<LoginScreenMindcare> createState() => _LoginScreenMindcareState();
}

class _LoginScreenMindcareState extends State<LoginScreenMindcare> {
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
              //  LOGO DI ATAS
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 40,
                ),
                child: Row(
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mindcare",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Your mental wellness companion",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 109, 106, 106),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 30,
                ),
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
                      //TEKS WELCOME
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Sign in to continue",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      //EMAIL
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
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

                      //PASSWORD
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
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
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFF3D8BFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      //SIGN IN BUTTON
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
                                msg: "Login successful",
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      //DIVIDER
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
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

                      const SizedBox(height: 25),

                      //GOOGLE BUTTON
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
                            // Fluttertoast.showToast(
                            //   msg: "Google Sign In clicked",
                            // );
                          },
                          // icon: Image.asset(
                          //   "assets/images/google.png",
                          //   height: 20,
                          //   width: 20,
                          // ),
                          label: const Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      //SIGN UP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrasiScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign In",
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
