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
    // mengecek apakah pin valid atau tidak
    vPin = PasarAjaValidation.pin(pin);

    // jika pin valid
    if (vPin.status == true) {
      _message = '';
      onValidateKonf(pin, konf);
    } else {
      _message = vPin.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Untuk mengecek apakah konfirmasi pin cocok atau tidak
  ///
  void onValidateKonf(String pin, String konf) {
    // mengecek apakah konfirmasi pin valid atau tidak
    vKonf = PasarAjaValidation.konfirmasiPin(pin, konf);

    // jika konfirmasi pin cocok
    if (vKonf.status == true) {
      _message = '';
    } else {
      _message = vKonf.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Enable & disable button, sesuai dengan valid atau tidaknya data
  ///
  void _updateButonState() {
    if (vPin.status == null || vKonf.status == null) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vPin.status == false || vKonf.status == false) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      _buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  /// Aksi saat button 'Ganti Pin' ditekan
  Future<void> onPressedButtonGantiPin({
    required String phone,
    required String pin,
  }) async {
    try {
      // show loading button
      buttonState = AuthFilledButton.stateLoadingButton;

      await PasarAjaConstant.buttonDelay;

      // memanggil controller untuk menganti pin dari user
      final dataState = await _changeController.changePin(
        phone: phone,
        pin: pin,
      );

      // jika pin berhasil diubah
      if (dataState is DataSuccess) {
        // close loading button
        buttonState = AuthFilledButton.stateEnabledButton;

        // menampilkan dialog informasi bahwa pin berhasil diubah
        await PasarAjaMessage.showInformation(
          "PIN berhasil diubah, Silahkan Login lagi dengan PIN yang baru.",
        );

        // kembali ke halaman welcome
        Get.offAll(
          const WelcomePage(),
          transition: Transition.circularReveal,
          duration: PasarAjaConstant.transitionDuration,
        );
      }

      // jika pin gagal diubah
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        _message = dataState.error!.error.toString();
        notifyListeners();
        PasarAjaMessage.showSnackbarWarning(message.toString());
      }

      // close loading button
      buttonState = AuthFilledButton.stateEnabledButton;
    } catch (ex) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = ex.toString();
      notifyListeners();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// reset semua data pada provider
  void resetData() {
    pinCont.text = '';
    konfCont.text = '';
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    vPin = PasarAjaValidation.pin(null);
    vKonf = PasarAjaValidation.konfirmasiPin(null, null);
    _obscurePass = true;
    _obscureKonf = true;
    notifyListeners();
  }
}
