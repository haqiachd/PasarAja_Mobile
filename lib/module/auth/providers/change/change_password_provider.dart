import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/confirm_dialog.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
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
    vPass = PasarAjaValidation.password(password);

    // enable and disable button
    if (vPass.status == true) {
      message = '';
      onValidateKonf(password, konf);
    } else {
      message = vPass.message ?? PasarAjaConstant.unknownError;
    }
    _updateButonState();
  }

  /// Untuk mengecek apakah konfirmasi password cocok atau tidak
  ///
  void onValidateKonf(String password, String konf) {
    vKonf = PasarAjaValidation.konfirmasiPassword(password, konf);

    if (vKonf.status == true) {
      message = '';
    } else {
      message = vKonf.message ?? PasarAjaConstant.unknownError;
    }
    _updateButonState();
  }

  void _updateButonState() {
    if (vPass.status == null || vKonf.status == null) {
      buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vPass.status == false || vKonf.status == false) {
      buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  Future<void> onPressedGantiPassword({
    required String email,
    required String password,
  }) async {
    try {
      _buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();

      await PasarAjaConstant.buttonDelay;

      // call api ganti sandi
      final dataState = await _changeController.changePassword(
        email: email,
        password: password,
      );

      if (dataState is DataSuccess) {
        final result = await Get.dialog<bool>(
          const ConfirmDialog(
            title: 'Konfirmasi',
            message: 'Apakah Anda yakin ingin melanjutkan?',
          ),
        );

        if (result != null && result) {
          Get.offAll(
            const WelcomePage(),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 500),
          );
          Fluttertoast.showToast(msg: "Password berhasil Diubah");
        } else {
          print('Anda memilih Tidak atau dialog ditutup');
        }
      }

      if (dataState is DataFailed) {
        Fluttertoast.showToast(
          msg: dataState.error!.message ?? PasarAjaConstant.unknownError,
        );
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
    pwCont.text = '';
    konfCont.text = '';
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    vPass = PasarAjaValidation.password(null);
    vKonf = PasarAjaValidation.konfirmasiPassword(null, null);
    obscurePass = true;
    obscureKonf = true;
    notifyListeners();
  }
}
