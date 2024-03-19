import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
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

    // jika pin dan konfirmasi pin cocok
    if (createdPin == konfPin) {
      _message = '';
      _buttonState = AuthFilledButton.stateEnabledButton;
    } else {
      message = 'PIN tidak cocok';
      _buttonState = AuthFilledButton.stateDisabledButton;
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
      // show button loading
      buttonState = AuthFilledButton.stateLoadingButton;

      await PasarAjaConstant.buttonDelay;

      // memanggil api untuk melakukan registrasi
      final dataState = await _signUpController.signUp(
        phone: user.phoneNumber!,
        email: user.email!,
        fullName: user.fullName!,
        pin: createdPin,
        password: user.password!,
      );

      // jika register berhasil
      if (dataState is DataSuccess) {
        // close button loading
        buttonState = AuthFilledButton.stateEnabledButton;

        // menapilkan dialog informasi register berhasil
        await PasarAjaMessage.showInformation(
          'Register berhasil, Silahkan login dengan akun yang baru!',
          actionYes: 'Login',
        );

        // ke halaman welcome
        Get.offAll(
          const WelcomePage(),
          transition: Transition.circularReveal,
          duration: PasarAjaConstant.transitionDuration,
        );
      }

      // jika reister gagal
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        _message = dataState.error!.error ?? PasarAjaConstant.unknownError;
        _buttonState = AuthFilledButton.stateEnabledButton;
        notifyListeners();
        Fluttertoast.showToast(msg: message.toString());
      }
    } catch (ex) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
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
