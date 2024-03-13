import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasarAjaUserService {
  static const phone = 'phone';
  static const email = 'email';
  static const fullName = 'fullname';

  /// cek apakah user sudah login atau belum
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email) != null;
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
    await prefs.setString(email, user.email!);
    await prefs.setString(fullName, user.fullName!);
  }

  /// logout
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(phone);
    await prefs.remove(email);
    await prefs.remove(fullName);
  }
}
