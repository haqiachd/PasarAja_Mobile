import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/change_controller.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/filled_button.dart';

class ChangePinProvider extends ChangeNotifier {
  // validation, controller
  ValidationModel vPin = PasarAjaValidation.pin(null);
  ValidationModel vKonf = PasarAjaValidation.konfirmasiPassword(null, null);
  final TextEditingController konfCont = TextEditingController();
  final TextEditingController pinCont = TextEditingController();
  final ChangeController _changeController = ChangeController();

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

  // obscure password
  bool _obscurePass = false;
  bool get obscurePass => _obscurePass;
  set obscurePass(bool b) {
    _obscurePass = b;
    notifyListeners();
  }

  // obscure konfirmasi passsword
  bool _obscureKonf = false;
  bool get obscureKonf => _obscureKonf;
  set obscureKonf(bool b) {
    _obscureKonf = b;
    notifyListeners();
  }

  /// Untuk mengecek apakah pin yang diinputkan valid atau tidak
  ///
  void onValidatePin(String pin, String konf) {
    vPin = PasarAjaValidation.pin(pin);

    // enable and disable button
    if (vPin.status == true) {
      message = '';
      onValidateKonf(pin, konf);
    } else {
      message = vPin.message ?? PasarAjaConstant.unknownError;
    }
    _updateButonState();
  }

  /// Untuk mengecek apakah konfirmasi password cocok atau tidak
  ///
  void onValidateKonf(String pin, String konf) {
    vKonf = PasarAjaValidation.konfirmasiPin(pin, konf);

    if (vKonf.status == true) {
      message = '';
    } else {
      message = vKonf.message ?? PasarAjaConstant.unknownError;
    }
    _updateButonState();
  }

  void _updateButonState() {
    if (vPin.status == null || vKonf.status == null) {
      buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vPin.status == false || vKonf.status == false) {
      buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  Future<void> onPressedButtonGantiPin({
    required String phone,
    required String pin,
  }) async {
    try {
      _buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();

      await PasarAjaConstant.buttonDelay;

      final dataState = await _changeController.changePin(
        phone: phone,
        pin: pin,
      );

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation(
          "PIN berhasil diubah, Silahkan Login lagi dengan PIN yang baru.",
        );

        Fluttertoast.showToast(msg: "PIN berhasil diubah, Silahkan Login Lagi");
        Get.offAll(
          const WelcomePage(),
          transition: Transition.circularReveal,
          duration: PasarAjaConstant.transitionDuration,
        );
      }

      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        _message = dataState.error!.error.toString();
        PasarAjaUtils.showWarning(_message.toString());
      }

      _buttonState = AuthFilledButton.stateEnabledButton;
      notifyListeners();
    } catch (ex) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  /// reset semua data pada provider
  void resetData() {
    pinCont.text = '';
    konfCont.text = '';
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    vPin = PasarAjaValidation.pin(null);
    vKonf = PasarAjaValidation.konfirmasiPin(null, null);
    obscurePass = true;
    obscureKonf = true;
    notifyListeners();
  }
}
