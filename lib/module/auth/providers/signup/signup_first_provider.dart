import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_second_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/filled_button.dart';

class SignUpFirstProvider extends ChangeNotifier {
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
    vPhone = PasarAjaValidation.phone(phone);
    // enable and disable button
    if (vPhone.status == true) {
      buttonState = AuthFilledButton.stateEnabledButton;
      message = '';
    } else {
      buttonState = AuthFilledButton.stateDisabledButton;
      message = vPhone.message ?? PasarAjaConstant.unknownError;
    }
    notifyListeners();
  }

  /// Aksi saat button 'Berikutnya' ditekan,
  ///
  Future<void> onPressedButtonBerikutnya({
    required String phone,
  }) async {
    try {
      // call loading
      buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 3));

      // memanggil api untuk mengecek nomor hp exist atau tidak
      DataState dataState = await _authController.isExistPhone(phone: phone);

      // jika nomor hp exist
      if (dataState is DataSuccess) {
        PasarAjaUtils.triggerVibration();
        message = 'Nomor HP sudah terpakai';
      }

      // jika nomor hp tidak exist
      if (dataState is DataFailed) {
        Fluttertoast.showToast(msg: 'Nomor not exist');
        Get.to(
          SignUpCreatePage(phone: phone),
          transition: Transition.rightToLeft,
          duration: PasarAjaConstant.transitionDuration,
        );
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

  void onPressedButtonSkip() {
    Get.to(
      const SignUpCreatePage(phone: ''),
      transition: Transition.rightToLeft,
      duration: PasarAjaConstant.transitionDuration,
    );
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
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    vPhone = PasarAjaValidation.phone('');
    notifyListeners();
  }
}
