import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signin_controller.dart';
import 'package:pasaraja_mobile/module/auth/views/change/change_pin_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class VerifyPinProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPin = PasarAjaValidation.pin(null);
  SignInController _signInController = SignInController();

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
    required String phone,
    required String pin,
  }) async {
    try {
      // call loading
      buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();

      // request api untuk login
      final dataState = await _signInController.signInPhone(
        phone: phone,
        pin: pin,
      );

      // jika login berhasil
      if (dataState is DataSuccess) {
        Get.showSnackbar(
          GetSnackBar(
            title: 'Informasi',
            message: 'Login Berhasil',
            duration: PasarAjaConstant.transitionDuration * 2,
          ),
        );
      }

      // jika login gagal
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        message = dataState.error!.error ?? PasarAjaConstant.unknownError;
        Fluttertoast.showToast(msg: message.toString());
      }

      // update button state
      buttonState = AuthFilledButton.stateEnabledButton;
      notifyListeners();
    } catch (ex) {
      buttonState = AuthFilledButton.stateEnabledButton;
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  Future<void> onPressedButtonLupaPin({
    required String phone,
  }) async {
    try {
      PasarAjaUtils.showLoadingDialog();

      await Future.delayed(const Duration(seconds: 3));

      Get.back();
      Fluttertoast.showToast(msg: phone);

      Get.to(
        const ChangePinPage(),
        transition: Transition.leftToRight,
        duration: PasarAjaConstant.transitionDuration,
      );
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
