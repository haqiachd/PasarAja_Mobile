import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signin_controller.dart';
import 'package:pasaraja_mobile/module/auth/controllers/verification_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:pasaraja_mobile/module/customer/views/customer_main_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/merchant_main_page.dart';

class VerifyPinProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPin = PasarAjaValidation.pin(null);
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

  /// Untuk mengecek apakah nomor hp yang diinputkan valid atau tidak
  ///
  void onValidatePhone(String pin) {
    // mengecek nomor hp valid atau tidak
    vPin = PasarAjaValidation.pin(pin);
    // enable and disable button
    if (vPin.status == true) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = '';
    } else {
      _buttonState = AuthFilledButton.stateDisabledButton;
      _message = vPin.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    notifyListeners();
  }

  /// Aksi saat user selesai menginputkan PIN
  ///
  Future<void> onCompletePin({
    required String phone,
    required String pin,
  }) async {
    try {
      // show loading button
      buttonState = AuthFilledButton.stateLoadingButton;

      // memanggil controller untuk melakukan login dengan nomor hp
      final dataState = await _signInController.signInPhone(
        phone: phone,
        pin: pin,
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
        Fluttertoast.showToast(msg: message.toString());
      }

      // update button state
      buttonState = AuthFilledButton.stateEnabledButton;
    } catch (ex) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  /// Aksi saat button 'Lupa Pin' ditekan
  ///
  Future<void> onPressedButtonLupaPin({
    required String phone,
  }) async {
    try {
      // menampilkan dialog konfirmasi untuk mengirimkan kode otp
      final confirm = await PasarAjaMessage.showConfirmation(
        "Kami akan mengirimkan kode OTP ke alamat email Anda.",
      );

      // jika user menekan tombol yes
      if (confirm) {
        // memanggil loading ui
        PasarAjaUtils.showLoadingDialog();

        await PasarAjaConstant.buttonDelay;

        // memanggil controller untuk mengirimkan kode otp
        final dataState = await _verifyController.requestOtpByPhone(
          phone: phone,
        );

        // menutup loading ui
        Get.back();

        // jika otp berhasil dikirim
        if (dataState is DataSuccess) {
          // membuka halaman verifikasi otp dengan data otp dari controller
          final model = dataState.data as VerificationModel; // data otp
          Get.to(
            VerifyOtpPage(
              verificationModel: model,
              from: VerifyOtpPage.fromForgotPin,
              recipient: phone,
              data: phone,
            ),
            transition: Transition.leftToRight,
            duration: PasarAjaConstant.transitionDuration,
          );
        }

        // jika gagal
        if (dataState is DataFailed) {
          message = dataState.error!.error.toString();
          Fluttertoast.showToast(msg: message.toString());
        }
      }
    } catch (ex) {
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// reset semua data pada provider
  void resetData() {
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    vPin = PasarAjaValidation.pin('');
    notifyListeners();
  }
}
