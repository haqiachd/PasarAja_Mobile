import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signin_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/verification_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignInGoogleProvider extends ChangeNotifier {
  // controller, validator, services
  ValidationModel vEmail = PasarAjaValidation.email(null);
  ValidationModel vPass = PasarAjaValidation.password(null);
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();
  final AuthController _authController = AuthController();
  final SignInController _signInController = SignInController();
  final VerificationController _verifyController = VerificationController();

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
  bool _obscure = false;
  bool get obscure => _obscure;
  set obscure(bool b) {
    _obscure = b;
    notifyListeners();
  }

  /// Untuk mengecek apakah nomor hp yang diinputkan valid atau tidak
  ///
  void onValidateEmail(String email) {
    vEmail = PasarAjaValidation.email(email);

    // enable and disable button
    if (vEmail.status == true) {
      message = '';
    } else {
      message = vEmail.message ?? PasarAjaConstant.unknownError;
    }
    _updateButonState();
  }

  void onValidatePassword(String password) {
    vPass = PasarAjaValidation.password(password);

    // enable and disable button
    if (vPass.status == true) {
      message = '';
    } else {
      message = vEmail.message ?? PasarAjaConstant.unknownError;
    }
    _updateButonState();
  }

  void _updateButonState() {
    if (vEmail.status == null || vPass.status == null) {
      buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vEmail.status == false || vPass.status == false) {
      buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  Future<void> onPressedButtonMasuk({
    required String email,
    required String password,
  }) async {
    try {
      // call loading
      buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();

      // memanggil api untuk melakukan login dengan email dan password
      final DataState dataState = await _signInController.signInEmail(
        email: email,
        password: password,
      );

      if (dataState is DataSuccess) {
        Fluttertoast.showToast(msg: "Login berhasil");
      }

      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        message = dataState.error!.error ?? PasarAjaConstant.unknownError;
        Fluttertoast.showToast(msg: message.toString());
      }

      buttonState = AuthFilledButton.stateEnabledButton;
      notifyListeners();
    } catch (ex) {
      buttonState = AuthFilledButton.stateEnabledButton;
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  Future<void> onTapButtonLupaSandi({required String email}) async {
    try {
      if (PasarAjaValidation.email(email).status == true) {
        // mengecek apakah email yang dibuat lupa sandi exist atau tidak
        DataState dataState = await _authController.isExistEmail(
          email: email,
        );

        // jika email exist
        if (dataState is DataSuccess) {
          // mengirim kode otp ke email
          dataState = await _verifyController.requestOtp(
            email: emailCont.text,
          );

          // jika otp berhasil dikirim
          if (dataState is DataSuccess) {
            Get.to(
              VerifyOtpPage(
                verificationModel: dataState.data as VerificationModel,
                from: VerifyOtpPage.fromLoginGoogle,
                recipient: emailCont.text,
              ),
              transition: Transition.downToUp,
            );
          }

          // jika otp gagal dikirim
          if (dataState is DataFailed) {
            PasarAjaUtils.triggerVibration();
            message = dataState.error!.error ?? PasarAjaConstant.unknownError;
            Fluttertoast.showToast(msg: message.toString());
          }
        }

        // jika email tidak exist
        if (dataState is DataFailed) {
          PasarAjaUtils.triggerVibration();
          message = dataState.error!.error ?? PasarAjaConstant.unknownError;
          Fluttertoast.showToast(msg: message.toString());
        }
      } else {
        Get.snackbar(
          'Info',
          'Email tidak valid',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (ex) {
      //
    }
  }

  Future<void> onTapButtonLoginGoogle({
    required String email,
  }) async {
    // send login request
    DataState dataState = await _signInController.signInGoogle(
      email: email,
    );

    if (dataState is DataSuccess) {
      Fluttertoast.showToast(msg: "Login Berhasil");
    }

    if (dataState is DataFailed) {
      PasarAjaUtils.triggerVibration();
      message = dataState.error!.error ?? PasarAjaConstant.unknownError;
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  /// reset semua data pada provider
  void resetData() {
    emailCont.text = '';
    passCont.text = '';
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    obscure = false;
    vEmail = PasarAjaValidation.email('');
    vPass = PasarAjaValidation.password('');
    notifyListeners();
  }
}
