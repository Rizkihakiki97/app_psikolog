import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String userId = "userId";       // Firebase UID (String)
  static const String username = "username";
  static const String userEmail = "userEmail"; // Simpan email user

  // Save login status
  static Future<void> saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLogin, value);
  }

  // Get login status
  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  // Remove user session
  static Future<void> removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLogin);
    await prefs.remove(username);
    await prefs.remove(userId);
    await prefs.remove(userEmail);

    print("🧹 User session removed");
  }

  // SAVE USER DATA (uid, name, email)
  static Future<void> saveUserData({
    required String uid,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(userId, uid);
    await prefs.setString(username, name);
    await prefs.setString(userEmail, email);

    print("✅ User data saved: uid=$uid, name=$name, email=$email");
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(username);
    print("📦 Retrieved username: $name");
    return name;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmail);
  }
}
