import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/change_password_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/change_pin_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signin_google_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signin_phone_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signup_first_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signup_fourth_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signup_second_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signup_third_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/test_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/verify_otp_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/verify_pin_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/welcome_page.dart';

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
        return _materialRoute(const VerifyPinPage());
      case RouteName.verifyCode:
        return _materialRoute(const VerifyOtpPage());
      case RouteName.signupFirst:
        return _materialRoute(const SignUpPhonePage());
      case RouteName.signupSecond:
        return _materialRoute(const SignUpCreatePage());
      case RouteName.signupThird:
        return _materialRoute(const SingUpCreatePin());
      case RouteName.signupFourth:
        return _materialRoute(const SignUpConfirmPage());
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
