import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserLevel {
  penjual,
  pembeli,
}

class PasarAjaUserService {
  static const phone = 'phone';
  static const email = 'email';
  static const fullName = 'fullname';
  static const level = 'level';
  static const photo = 'photo';

  /// cek apakah user sudah login atau belum
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString(email).toString();
    return userEmail.isNotEmpty && userEmail.trim().isNotEmpty;
  }

  // get user data
  static Future<String> getUserData(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(data) ?? '';
  }

  /// login
  static Future<void> login(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(phone, user.phoneNumber ?? '');
    await prefs.setString(email, user.email ?? '');
    await prefs.setString(fullName, user.fullName ?? '');
    await prefs.setString(level, user.level ?? '');
    await prefs.setString(phone, user.photo ?? '');
  }

  /// logout
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(phone);
    await prefs.remove(email);
    await prefs.remove(fullName);
  }
}
