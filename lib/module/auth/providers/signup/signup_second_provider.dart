import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/verification_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpSecondProvider extends ChangeNotifier {
  // controller, validator
  ValidationModel vEmail = PasarAjaValidation.email(null);
  ValidationModel vName = PasarAjaValidation.name(null);
  ValidationModel vPass = PasarAjaValidation.password(null);
  ValidationModel vKonf = PasarAjaValidation.konfirmasiPassword(null, null);
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController konfCont = TextEditingController();
  final AuthController _authController = AuthController();
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

  /// Untuk mengecek apakah email yang diinputkan valid atau tidak
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

  /// Untuk mengecek apakah nama yang diinputkan valid atau tidak
  ///
  void onValidateName(String nama) {
    vName = PasarAjaValidation.name(nama);

    // enable and disable button
    if (vName.status == true) {
      message = '';
    } else {
      message = vName.message ?? PasarAjaConstant.unknownError;
    }
    _updateButonState();
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
    if (vEmail.status == null ||
        vName.status == null ||
        vPass.status == null ||
        vKonf.status == null) {
      buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vEmail.status == false ||
        vName.status == false ||
        vPass.status == false ||
        vKonf.status == false) {
      buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  Future<void> onPressedButtonBerikutnya({
    required String phone,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      _buttonState = AuthFilledButton.stateLoadingButton;
      notifyListeners();

      await PasarAjaConstant.buttonDelay;

      DataState dataState = await _authController.isExistEmail(
        email: email,
      );

      if (dataState is DataSuccess) {
        PasarAjaUtils.showWarning("Email tersebut sudah terdaftar");
        // reset data email
        PasarAjaUtils.triggerVibration();
        emailCont.text = '';
        onValidateEmail('');
        // close loading button
        _buttonState = AuthFilledButton.stateEnabledButton;
        notifyListeners();
      }

      // jika email belum terdaftar
      if (dataState is DataFailed) {
        // close loading button
        _buttonState = AuthFilledButton.stateEnabledButton;
        notifyListeners();

        // menampilkan konfirmasi dialog kirim otp
        final bool confirm = await PasarAjaMessage.showConfirmation(
          "Kami akan mengirimkan kode OTP ke email Anda",
        );

        // jika user menekan tombol yes
        if (confirm) {
          // menampilkan dialog loading
          PasarAjaUtils.showLoadingDialog();

          // memanggil controller untuk mengirimkan otp
          dataState = await _verifyController.requestOtp(email: email);

          // close dialog
          Get.back();

          // otp berhasil terikirm
          if (dataState is DataSuccess) {
            Get.to(
              VerifyOtpPage(
                verificationModel: dataState.data as VerificationModel,
                from: VerifyOtpPage.fromRegister,
                recipient: email,
                data: UserModel(
                  phoneNumber: phone,
                  email: email,
                  fullName: fullName,
                  password: password,
                ),
              ),
              transition: Transition.downToUp,
            );
          }

          // data otp gagal dikirim
          if (dataState is DataFailed) {
            PasarAjaUtils.triggerVibration();
            _message = dataState.error!.error ?? 'fail send otp';
            Fluttertoast.showToast(msg: message.toString());
            _buttonState = AuthFilledButton.stateEnabledButton;
            notifyListeners();
          }
        }
      }
    } catch (ex) {
      buttonState = AuthFilledButton.stateEnabledButton;
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  Future<void> onTapButtonLoginGoogle({
    required GoogleSignInAccount user,
  }) async {
    try {
      if (user.email.isEmpty) {
        return;
      }
      // send login request
      PasarAjaUtils.showLoadingDialog();

      await Future.delayed(const Duration(seconds: 3));

      final dataState = await _authController.isExistEmail(
        email: user.email,
      );

      Get.back();

      if (dataState is DataSuccess) {
        PasarAjaUtils.showWarning("Email tersebut sudah terdaftar");
        // reset data email dan nama
        PasarAjaUtils.triggerVibration();
        emailCont.text = '';
        nameCont.text = '';
        onValidateEmail('');
        onValidateName('');
      }

      if (dataState is DataFailed) {
        final email = user.email;
        final name = user.displayName ?? '';
        // show data
        emailCont.text = email;
        nameCont.text = name;
        // validasi data
        onValidateEmail(email);
        onValidateName(name);
      }
    } catch (ex) {
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// reset semua data pada provider
  void resetData() {
    emailCont.text = '';
    nameCont.text = '';
    pwCont.text = '';
    konfCont.text = '';
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    obscurePass = true;
    obscureKonf = true;
    vEmail = PasarAjaValidation.email(null);
    vName = PasarAjaValidation.name(null);
    vPass = PasarAjaValidation.password(null);
    vKonf = PasarAjaValidation.konfirmasiPassword(null, null);
    notifyListeners();
  }
}
