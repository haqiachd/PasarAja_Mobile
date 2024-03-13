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
    // mengecek pin valid atau tidak
    vPin = PasarAjaValidation.pin(pin);
    // jika pin valid
    if (vPin.status == true) {
      _message = '';
    } else {
      _message = vPin.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  /// Enable & disable button, sesuai dengan valid atau tidaknya data
  ///
  void _updateButonState() {
    if (vPin.status == null) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vPin.status == false) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      _buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  /// Aksi saat button 'Berikutnya' ditekan
  ///
  void onPressedButtonBerikutnya({
    required UserModel user,
    required String createdPin,
  }) {
    DMethod.log('Password From Third Provider: $createdPin');
    // membuka halaman singup fourth
    Get.to(
      SignUpFourthPage(
        user: user,
        createdPin: createdPin,
      ),
      transition: Transition.downToUp,
    );
  }

  /// reset semua data pada provider
  void resetData() {
    pinCont.text = '';
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    vPin = PasarAjaValidation.phone(null);
    notifyListeners();
  }
}
