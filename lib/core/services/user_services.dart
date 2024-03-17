import 'package:pasaraja_mobile/core/utils/validations.dart';
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
  static const deviceToken = 'device_token';

  /// cek apakah user sudah login atau belum
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // get email
    String userEmail = prefs.getString(email).toString();
    // validasi email
    ValidationModel validate = PasarAjaValidation.email(userEmail);
    return validate.status == true;
  }

  // get user data
  static Future<String> getUserData(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(data)) {
      return prefs.getString(data) ?? '';
    } else {
      return '';
    }
  }

  // set user data
  static Future<void> setUserData(String data, String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(data, value ?? '');
  }

  /// login
  static Future<void> login(UserModel user) async {
    await setUserData(phone, user.phoneNumber);
    await setUserData(email, user.email);
    await setUserData(fullName, user.fullName);
    await setUserData(level, user.level);
    await setUserData(photo, user.photo);
  }

  /// logout
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(phone);
    await prefs.remove(email);
    await prefs.remove(fullName);
    await prefs.remove(photo);
    await prefs.remove(level);
    await prefs.remove(deviceToken);
  }
}
