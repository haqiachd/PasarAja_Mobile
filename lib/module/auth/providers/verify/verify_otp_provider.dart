import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/change/change_password_page.dart';
import 'package:pasaraja_mobile/module/auth/views/change/change_pin_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_third_page.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class VerifyOtpProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPin = PasarAjaValidation.pin(null);

  // button state status
  int _buttonState = AuthFilledButton.stateDisabledButton;
  int get buttonState => _buttonState;
  set buttonState(int n) {
    _buttonState = n;
    notifyListeners();
  }

  // error message
  Object _message = '';
  Object get message => _message;
  set message(Object m) {
    _message = m;
    notifyListeners();
  }

  /// Untuk mengecek apakah pin yang diinputkan valid atau tidak
  ///
  void onValidatePhone(String pin) {
    vPin = PasarAjaValidation.pin(pin);
    // enable and disable button
    if (vPin.status == true) {
      buttonState = AuthFilledButton.stateEnabledButton;
      message = '';
    } else {
      buttonState = AuthFilledButton.stateDisabledButton;
      message = vPin.message ?? PasarAjaConstant.unknownError;
    }
    notifyListeners();
  }

  /// Aksi saat user selesai menginputkan PIN
  ///
  Future<void> onCompletePin({
    required int from,
    required VerificationModel verify,
    required String otp,
    required dynamic data,
  }) async {
    try {
      // cek apakah kode otp valid atau tidak
      if (otp == verify.otp) {
        await Future.delayed(const Duration(seconds: 1));
        switch (from) {
          // verifikasi lupa password
          case VerifyOtpPage.fromLoginGoogle:
            Get.off(
              ChangePasswordPage(email: data as String),
              transition: Transition.leftToRight,
              duration: PasarAjaConstant.transitionDuration,
            );
          // verifikasi register
          case VerifyOtpPage.fromRegister:
            Get.off(
              SignUpThirdPage(user: data as UserModel),
              transition: Transition.leftToRight,
              duration: PasarAjaConstant.transitionDuration,
            );
          case VerifyOtpPage.fromForgotPin:
            Get.off(
              ChangePinPage(phone: data as String),
              transition: Transition.leftToRight,
              duration: PasarAjaConstant.transitionDuration,
            );
          default:
            Fluttertoast.showToast(msg: "default error");
        }
      } else {
        message = 'Kode OTP tidak cocok!';
        PasarAjaUtils.triggerVibration();
      }

      notifyListeners();
    } catch (ex) {
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  /// reset semua data pada provider
  void resetData() {
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    vPin = PasarAjaValidation.pin('');
    notifyListeners();
  }
}
