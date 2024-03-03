import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';

class SignInGoogleController {
  /// Login Email
  static Future<UserModel> loginEmail({
    required String email,
    required String password,
  }) async {
    var apiUrl = Uri.parse("${PasarAjaConstant.baseUrl}/auth/signin/email");

    var result = await http.post(apiUrl, body: {
      "email": email,
      "password": password,
    });

    // print('result -> ${result.body}');
    if (result.statusCode == 200) {
      var json = jsonDecode(result.body);
      // print(json);
      return UserModel.fromJson(json);
    } else {
      // print('Login gagal');
      throw Exception('request gagal -> ${result.statusCode}');
    }
  }

  static Future<UserModel> loginGoogle({String? email}) async {
    final apiUrl = Uri.parse("${PasarAjaConstant.baseUrl}/auth/signin/google");

    var result = await http.post(apiUrl, body: {
      "email": email,
    });

    if (result.statusCode == 200) {
      var json = jsonDecode(result.body);
      return UserModel.fromJson(json);
    } else {
      throw Exception('request gagal -> ${result.statusCode}');
    }
  }
}

void main(List<String> args) async {
  // final data = await SignInGoogleController.loginEmail(
  //   email: "hakiahmad756@gmail.com",
  //   password: "Haqi.123s4",
  // );
  final data = await SignInGoogleController.loginGoogle(
    email: "hakiahmad756@gmail.com",
  );

  try {
    if (data.status == 'success') {
      print('Login berhasil');
      print(data.data['email']);
    } else {
      print('Login gagal');
    }
  } catch (ex) {
    print(ex);
  }
}
