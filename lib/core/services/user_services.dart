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
  static const shopId = 'id_shop';
  static const shopName = 'shop_name';
  static const shopPhone = 'shop_phone_number';
  static const shopDesc = 'shop_description';

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

  static Future<String> getEmailLogged() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(email)) {
      return prefs.getString(email) ?? '';
    } else {
      return '';
    }
  }

  static Future<int> getUserDataInt(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(data)) {
      return prefs.getInt(data) ?? 0;
    } else {
      return 0;
    }
  }

    static Future<int> getShopId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(shopId)) {
      return prefs.getInt(shopId) ?? 0;
    } else {
      return 0;
    }
  }

  // set user data
  static Future<void> setUserData(String data, String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(data, value ?? '');
  }

  static Future<void> setUserDataInt(String data, int? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(data, value ?? 0);
  }

  /// login
  static Future<void> login(UserModel user) async {
    await setUserData(phone, user.phoneNumber);
    await setUserData(email, user.email);
    await setUserData(fullName, user.fullName);
    await setUserData(level, user.level);
    await setUserData(photo, user.photo);
    if (user.level == 'Penjual') {
      await setUserDataInt(shopId, user.shopData?.idShop ?? 0);
      await setUserData(shopName, user.shopData?.shopName ?? '');
      await setUserData(shopDesc, user.shopData?.description ?? '');
      await setUserData(shopPhone, user.shopData?.phoneNumber ?? '');
    }
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
    await prefs.remove(shopId);
    await prefs.remove(shopName);
    await prefs.remove(shopPhone);
    await prefs.remove(shopDesc);
  }
}
