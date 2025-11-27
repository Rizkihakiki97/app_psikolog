import 'package:app_psikolog/preferences/preferences_handler.dart';
import 'package:app_psikolog/view/bottom_navbar.dart';
import 'package:app_psikolog/view/login_mindcare.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // FIX: Navigasi harus menunggu 1 frame dulu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 1)); // efek splash

    final isLogin = await PreferenceHandler.getLogin() ?? false;

    if (isLogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => BottomNavbar()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreenMindcare()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff256BE8),
              Color(0xff1CE2DA),
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image.asset("assets/images/mindcare1.png"),
        ),
      ),
    );
  }
}
