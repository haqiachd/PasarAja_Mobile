import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_pin_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/filled_button.dart';

class SignInPhoneProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPhone = PasarAjaValidation.phone(null);
  final TextEditingController phoneCont = TextEditingController();
  final AuthController _authController = AuthController();

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

  /// Untuk mengecek apakah nomor hp yang diinputkan valid atau tidak
  ///
  void onValidatePhone(String phone) {
    // mengecek apakah nomor hp valid atau tidak
    vPhone = PasarAjaValidation.phone(phone);

    // jika nomor hp valid
    if (vPhone.status == true) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = '';
    } else {
      _buttonState = AuthFilledButton.stateDisabledButton;
      _message = vPhone.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    notifyListeners();
  }

  /// Aksi saat button 'Berikutnya' ditekan,
  ///
  Future<void> onPressedButtonBerikutnya({
    required String phone,
  }) async {
    try {
      // show loading button
      buttonState = AuthFilledButton.stateLoadingButton;

      await PasarAjaConstant.buttonDelay;

      DMethod.log('phone number : $phone');
      // memanggil controller untuk mengecek nomor hp exist atau tidak
      final dataState = await _authController.isExistPhone(phone: phone);

      // jika nomor hp exist
      if (dataState is DataSuccess) {
        // membuka halaman verifikasi pin
        Get.to(
          VerifyPinPage(phone: phone),
          transition: Transition.downToUp,
          duration: PasarAjaConstant.transitionDuration,
        );
      }

      // jika nomor hp tidak exist
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        message = dataState.error!.error ?? PasarAjaConstant.unknownError;
        Fluttertoast.showToast(msg: message.toString());
      }

      // update button state
      buttonState = AuthFilledButton.stateEnabledButton;
    } catch (ex) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = ex.toString();
      notifyListeners();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// filter untuk menampilkan pesan error
  String? showHelperText(String? message) {
    if (message == null || message != 'Phone null' && message != 'Data valid') {
      return message;
    } else {
      return null;
    }
  }

  /// reset semua data pada provider
  void resetData() {
    phoneCont.text = '';
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    vPhone = PasarAjaValidation.phone(null);
    notifyListeners();
  }
}
