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
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class ChangePasswordProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPass = PasarAjaValidation.password(null);
  ValidationModel vKonf = PasarAjaValidation.password(null);
  final TextEditingController konfCont = TextEditingController();
  final TextEditingController pwCont = TextEditingController();
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

  /// Untuk mengecek apakah password yang diinputkan valid atau tidak
  ///
  void onValidatePassword(String password, String konf) {
    // mengecek apakah password valid atau tidak
    vPass = PasarAjaValidation.password(password);

    // jika password valid
    if (vPass.status == true) {
      _message = '';
      onValidateKonf(password, konf);
    } else {
      _message = vPass.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Untuk mengecek apakah konfirmasi password cocok atau tidak
  ///
  void onValidateKonf(String password, String konf) {
    // mengecek apakah konfirmasi password valid atau tidak
    vKonf = PasarAjaValidation.konfirmasiPassword(password, konf);

    // jika konfirmasi password cocok
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
    if (vPass.status == null || vKonf.status == null) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vPass.status == false || vKonf.status == false) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      _buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  /// Aksi saat button 'Ganti Password' ditekan
  ///
  Future<void> onPressedGantiPassword({
    required String email,
    required String password,
  }) async {
    try {
      // show loading button
      buttonState = AuthFilledButton.stateLoadingButton;

      await PasarAjaConstant.buttonDelay;

      // memanggil controller untuk mengganti password dari user
      final dataState = await _changeController.changePassword(
        email: email,
        password: password,
      );

      // jika password berhasil diubah
      if (dataState is DataSuccess) {
        // close loading button
        buttonState = AuthFilledButton.stateEnabledButton;

        // menampilkan dialog informasi, bahwa password berhasil diubah
        await PasarAjaMessage.showInformation(
          'Password berhasil diubah, Silahkan login lagi dengan password yang baru?',
          actionYes: 'Login',
        );

        // kembali ke halaman welcome
        Get.offAll(
          const WelcomePage(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 500),
        );
      }

      // jika password gagal diubah
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        Fluttertoast.showToast(
          msg: dataState.error!.error.toString(),
        );
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
    pwCont.text = '';
    konfCont.text = '';
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    vPass = PasarAjaValidation.password(null);
    vKonf = PasarAjaValidation.konfirmasiPassword(null, null);
    _obscurePass = true;
    _obscureKonf = true;
    notifyListeners();
  }
}
