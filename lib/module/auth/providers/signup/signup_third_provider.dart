import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_fourth_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpThirdProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPin = PasarAjaValidation.pin(null);
  final TextEditingController pinCont = TextEditingController();

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
  void onValidatePin(String pin) {
    vPin = PasarAjaValidation.pin(pin);
    // enable and disable button
    if (vPin.status == true) {
      message = '';
    } else {
      message = vPin.message ?? PasarAjaConstant.unknownError;
    }

    _updateButonState();
  }

  void _updateButonState() {
    if (vPin.status == null) {
      buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vPin.status == false) {
      buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  /// Aksi saat button buat pin di tekan
  /// 
  void onPressedButtonBerikutnya({
    required UserModel user,
    required String createdPin,
  }) {
    DMethod.log('Password From Third Provider: $createdPin');
    Get.to(
      SignUpConfirmPage(
        user: user,
        createdPin: createdPin,
      ),
      transition: Transition.downToUp,
    );
  }

    /// reset semua data pada provider
  void resetData() {
    pinCont.text = '';
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    vPin = PasarAjaValidation.phone(null);
    notifyListeners();
  }
}
