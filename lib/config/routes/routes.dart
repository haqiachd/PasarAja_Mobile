import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/change_password_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/change_pin_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signin_google_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signin_phone_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signup_second_page.dart';
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
      case RouteName.register:
        return _materialRoute(const SignUpCreatePage());
      default:
        return _materialRoute(const WelcomePage());
    }
  }

  static Route<dynamic> _materialRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }
}
