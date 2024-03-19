import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signin_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/verification_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:pasaraja_mobile/module/customer/views/customer_main_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/merchant_main_page.dart';

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

      // get device info
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      String deviceName = await PasarAjaUtils.getDeviceModel();

      // save device token
      PasarAjaUserService.setUserData(
        PasarAjaUserService.deviceToken,
        deviceToken,
      );

      // memanggil controller untuk melakukan login dengan email dan password
      final dataState = await _signInController.signInEmail(
        email: email,
        password: password,
        deviceName: deviceName,
        deviceToken: deviceToken ?? '',
      );

      // jika login berhasil
      if (dataState is DataSuccess) {
        // close loading button
        buttonState = AuthFilledButton.stateEnabledButton;
        Fluttertoast.showToast(msg: "Login Berhasil");

        // mendapatkan data user
        UserModel userData = dataState.data as UserModel;
        // menyimpan session login
        await PasarAjaUserService.login(userData);

        // get user level
        String level = userData.level!.toLowerCase();

        // jika user login sebagai penjual
        if (level == UserLevel.penjual.name) {
          // membuka halaman utama
          Get.to(
            const MerchantMainPage(),
          );
        }
        // jika user login sebagai pembeli
        else if (level == UserLevel.pembeli.name) {
          // membuka halaman utama
          Get.to(
            const CustomerMainPage(),
          );
        } else {
          Get.snackbar("ERROR", "Your account level is unknown");
        }
      }

      // jika login gagal
      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        message = dataState.error!.error ?? PasarAjaConstant.unknownError;
        // Fluttertoast.showToast(msg: message.toString());
        PasarAjaMessage.showSnackbarWarning(message.toString());
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
        PasarAjaMessage.showLoading();

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
            actionYes: 'Kirim',
            actionCancel: 'Batal',
          );

          // jika user menekan tombol yes
          if (confirm) {
            // menampilkan loding ui
            PasarAjaMessage.showLoading();

            // memanggil controller untuk mengirimkan kode otp ke email user
            dataState = await _verifyController.requestOtp(
              email: emailCont.text,
              type: VerificationController.forgotVerify,
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
        Fluttertoast.showToast(msg: vEmail.message ?? 'Email tidak valid');
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
    PasarAjaMessage.showLoading();

    await Future.delayed(const Duration(seconds: 3));

    // get device info
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    String deviceName = await PasarAjaUtils.getDeviceModel();

    // save device token
    PasarAjaUserService.setUserData(
      PasarAjaUserService.deviceToken,
      deviceToken,
    );

    // memanggil controller untuk melakukan login google dengan email yang diinputkan
    DataState dataState = await _signInController.signInGoogle(
      email: email,
      deviceName: deviceName,
      deviceToken: deviceToken ?? '',
    );

    // menutup loading ui
    Get.back();

    // jika login berhasil
    if (dataState is DataSuccess) {
      Fluttertoast.showToast(msg: "Login Berhasil");

      // mendapatkan data user
      UserModel userData = dataState.data as UserModel;
      // menyimpan session login
      await PasarAjaUserService.login(userData);

      // get user level
      String level = userData.level!.toLowerCase();

      // jika user login sebagai penjual
      if (level == UserLevel.penjual.name) {
        // membuka halaman utama
        Get.to(
          const MerchantMainPage(),
        );
      }
      // jika user login sebagai pembeli
      else if (level == UserLevel.pembeli.name) {
        // membuka halaman utama
        Get.to(
          const CustomerMainPage(),
        );
      } else {
        Get.snackbar("ERROR", "Your account level is unknown");
      }
    }

    // jika login gagal
    if (dataState is DataFailed) {
      PasarAjaUtils.triggerVibration();
      message = dataState.error!.error ?? PasarAjaConstant.unknownError;
      // Fluttertoast.showToast(msg: message.toString());
      PasarAjaMessage.showSnackbarWarning(message.toString());
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
