import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signup_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpFourthProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPin = PasarAjaValidation.pin(null);
  final TextEditingController pinCont = TextEditingController();
  final SignUpController _signUpController = SignUpController();

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
  void onValidatePin(String createdPin, String konfPin) {
    DMethod.log('Password Prov: $createdPin');
    DMethod.log('Konfirmasi Prov : $konfPin');
    if (createdPin == konfPin) {
      _message = '';
      buttonState = AuthFilledButton.stateEnabledButton;
    } else {
      message = 'PIN tidak cocok';
      buttonState = AuthFilledButton.stateDisabledButton;
    }

    notifyListeners();
  }

  /// Aksi saat button buat pin di tekan
  ///
  Future<void> onPressedButtonBuatAkun({
    required UserModel user,
    required String createdPin,
  }) async {
    try {
      // call loading
      buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();

      // memanggil api untuk login
      final dataState = await _signUpController.signUp(
        phone: user.phoneNumber!,
        email: user.email!,
        fullName: user.fullName!,
        pin: createdPin,
        password: user.password!,
      );

      if (dataState is DataSuccess) {
        Fluttertoast.showToast(
          msg: "Register berhasil, Silahkan login dengan akun yang baru",
        );

        await Future.delayed(const Duration(seconds: 2));

        Get.offAll(
          const WelcomePage(),
          transition: Transition.leftToRight,
        );
      }

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

  /// reset semua data pada provider
  void resetData() {
    pinCont.text = '';
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    vPin = PasarAjaValidation.phone(null);
    notifyListeners();
  }
}
