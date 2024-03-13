import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/main_page.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signin_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/verification_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignInGoogleProvider extends ChangeNotifier {
  // controller, validator
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
  bool _obscure = true;
  bool get obscure => _obscure;
  set obscure(bool b) {
    _obscure = b;
    notifyListeners();
  }

  /// Untuk mengecek apakah email yang diinputkan valid atau tidak
  ///
  void onValidateEmail(String email) {
    // mengecek apakah email valid atau tidak
    vEmail = PasarAjaValidation.email(email);

    // jika email valid
    if (vEmail.status == true) {
      _message = '';
    } else {
      _message = vEmail.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Untuk mengecek apakah password yang diinputkan valid atau tidak
  ///
  void onValidatePassword(String password) {
    // mengecek apakah password valid atau tidak
    vPass = PasarAjaValidation.password(password);

    // jika password valid
    if (vPass.status == true) {
      _message = '';
    } else {
      _message = vPass.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Enable & disable button, sesuai dengan valid atau tidaknya data
  ///
  void _updateButonState() {
    if (vEmail.status == null || vPass.status == null) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vEmail.status == false || vPass.status == false) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      _buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  /// Aksi saat button 'Masuk' ditekan
  ///
  Future<void> onPressedButtonMasuk({
    required String email,
    required String password,
  }) async {
    try {
      // show loading button
      buttonState = AuthFilledButton.stateLoadingButton;

      await PasarAjaConstant.buttonDelay;

      // memanggil controller untuk melakukan login dengan email dan password
      final dataState = await _signInController.signInEmail(
        email: email,
        password: password,
      );

      // jika login berhasil
      if (dataState is DataSuccess) {
        // close loading button
        buttonState = AuthFilledButton.stateEnabledButton;

        // menyimpan session login
        await PasarAjaUserService.login(dataState.data as UserModel);

        // membuka beranda
        Get.to(
          const MainPages(),
        );
      }

      // jika login gagal
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        message = dataState.error!.error ?? PasarAjaConstant.unknownError;
        // Fluttertoast.showToast(msg: message.toString());
        PasarAjaUtils.showWarning(message.toString());
      }

      // close loading button
      buttonState = AuthFilledButton.stateEnabledButton;
    } catch (ex) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  /// Aksi saat button 'Lupa Sandi' ditekan
  Future<void> onTapButtonLupaSandi({required String email}) async {
    try {
      // cek apakah email valid atau tidak
      if (PasarAjaValidation.email(email).status == true) {
        // show loading ui
        PasarAjaUtils.showLoadingDialog();

        await PasarAjaConstant.buttonDelay;

        // mengecek apakah email yang diinputkan exist atau tidak
        DataState dataState = await _authController.isExistEmail(
          email: email,
        );

        // close loading ui
        Get.back();

        // jika email exist
        if (dataState is DataSuccess) {
          // menampilkan dialog konfirmasi pengiriman otp
          final confirm = await PasarAjaMessage.showConfirmation(
            "Kami akan mengirimkan kode OTP ke alamat email Anda.",
          );

          // jika user menekan tombol yes
          if (confirm) {
            // menampilkan loding ui
            PasarAjaUtils.showLoadingDialog();

            // memanggil controller untuk mengirimkan kode otp ke email user
            dataState = await _verifyController.requestOtp(
              email: emailCont.text,
            );

            // menutup loading ui
            Get.back();

            // jika otp berhasil dikirim
            if (dataState is DataSuccess) {
              // membuka halaman verifikasi otp dengan data otp dari controller
              Get.to(
                VerifyOtpPage(
                  verificationModel:
                      dataState.data as VerificationModel, // data otp
                  from: VerifyOtpPage.fromLoginGoogle,
                  recipient: email,
                  data: email,
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
        }

        // jika email tidak exist
        if (dataState is DataFailed) {
          PasarAjaUtils.triggerVibration();
          message = dataState.error!.error ?? PasarAjaConstant.unknownError;
          Fluttertoast.showToast(msg: message.toString());
        }
      } else {
        // jika email tidak valid
        Get.snackbar(
          'Info',
          'Email tidak valid',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (ex) {
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// Aksi saat button 'Login Google' ditekan
  Future<void> onTapButtonLoginGoogle({
    required String email,
  }) async {
    // menampilkan loading ui
    PasarAjaUtils.showLoadingDialog();

    await Future.delayed(const Duration(seconds: 3));

    // memanggil controller untuk melakukan login google dengan email yang diinputkan
    DataState dataState = await _signInController.signInGoogle(
      email: email,
    );

    // menutup loading ui
    Get.back();

    // jika login berhasil
    if (dataState is DataSuccess) {
      // menyimpan session login
      await PasarAjaUserService.login(dataState.data as UserModel);
      Fluttertoast.showToast(msg: "Login Berhasil");

      // membuka halaman utama
      Get.to(
        const MainPages(),
      );
    }

    // jika login gagal
    if (dataState is DataFailed) {
      PasarAjaUtils.triggerVibration();
      message = dataState.error!.error ?? PasarAjaConstant.unknownError;
      // Fluttertoast.showToast(msg: message.toString());
      PasarAjaUtils.showWarning(message.toString());
    }
    notifyListeners();
  }

  /// reset semua data pada provider
  void resetData() {
    emailCont.text = '';
    passCont.text = '';
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    _obscure = true;
    vEmail = PasarAjaValidation.email(null);
    vPass = PasarAjaValidation.password(null);
    notifyListeners();
  }
}
