import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/views/change/change_password_page.dart';
import 'package:pasaraja_mobile/module/auth/views/change/change_pin_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signin/signin_google_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signin/signin_phone_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_first_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_fourth_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_second_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_third_page.dart';
import 'package:pasaraja_mobile/module/auth/views/test_page.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_pin_page.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.defRoute:
        return _materialRoute(const WelcomePage());
      case RouteName.loginPhone:
        return _materialRoute(const SignInPhonePage());
      case RouteName.loginGoogle:
        return _materialRoute(const SignInGooglePage());
      case RouteName.changePin:
        return _materialRoute(const ChangePinPage());
      case RouteName.changePw:
        return _materialRoute(const ChangePasswordPage());
      case RouteName.verifyPin:
        return _materialRoute(const VerifyPinPage(
          phone: '',
        ));
      case RouteName.verifyCode:
        return _materialRoute(VerifyOtpPage(
          from: settings.arguments as int,
          recipient: settings.arguments as String,
        ));
      case RouteName.signupFirst:
        return _materialRoute(const SignUpPhonePage());
      case RouteName.signupSecond:
        return _materialRoute(SignUpCreatePage(
          phone: settings.arguments as String,
        ));
      case RouteName.signupThird:
        return _materialRoute(const SingUpCreatePin(
          user: UserModel(),
        ));
      case RouteName.signupFourth:
        return _materialRoute(const SignUpConfirmPage(
          user: UserModel(),
          createdPin: '',
        ));
      case RouteName.testpage:
        return _materialRoute(const MyTestPage());
      default:
        return _materialRoute(const WelcomePage());
    }
  }

  static Route<dynamic> _materialRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }
}
