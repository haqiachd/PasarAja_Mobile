import 'package:d_method/d_method.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/verification_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/change/change_password_page.dart';
import 'package:pasaraja_mobile/module/auth/views/change/change_pin_page.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_third_page.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class VerifyOtpProvider extends ChangeNotifier {
  // validator, controller
  ValidationModel vPin = PasarAjaValidation.pin(null);
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

  // second and resend for otp
  int _second = 5;
  int _resent = 1;

  // error message
  Object _timeStatus = '';
  Object get timeStatus => _timeStatus;
  set timeStatus(Object m) {
    _timeStatus = m;
    notifyListeners();
  }

  /// Aksi saat user selesai menginputkan PIN
  ///
  Future<void> onCompletePin({
    required int from,
    required VerificationModel verify,
    required String otp,
    required dynamic data,
  }) async {
    try {
      DMethod.log('from -> $from');
      DMethod.log('verify -> ${verify.otp}');
      DMethod.log('otp -> $otp');
      DMethod.log('data -> $data');
      // cek apakah kode otp valid atau tidak
      if (otp == verify.otp) {
        // cek apakah otp masih berlaku atau tidak
        if (verify.expirationTime! >= DateTime.now().millisecondsSinceEpoch) {
          // stop timer yang sedang berjalan
          _second = -1;

          await Future.delayed(const Duration(seconds: 1));

          // action type saat otp valid
          switch (from) {
            // jika verifikasi dari lupa password
            case VerifyOtpPage.fromLoginGoogle:
              Get.off(
                ChangePasswordPage(email: data as String),
                transition: Transition.leftToRight,
                duration: PasarAjaConstant.transitionDuration,
              );
            // jika verifikasi dari register
            case VerifyOtpPage.fromRegister:
              Get.off(
                SignUpThirdPage(user: data as UserModel),
                transition: Transition.leftToRight,
                duration: PasarAjaConstant.transitionDuration,
              );
            // jika verifikasi dari lupa pin
            case VerifyOtpPage.fromForgotPin:
              Get.off(
                ChangePinPage(phone: data as String),
                transition: Transition.leftToRight,
                duration: PasarAjaConstant.transitionDuration,
              );
            default:
              Fluttertoast.showToast(msg: "default error");
          }
        } else {
          _message = 'Kode OTP telah Kadaluarsa';
          Fluttertoast.showToast(msg: _message.toString());
          PasarAjaUtils.triggerVibration();
        }
      } else {
        // jika kode otp tidak cocook
        _message = 'Kode OTP tidak cocok!';
        PasarAjaUtils.triggerVibration();
      }

      notifyListeners();
    } catch (ex) {
      ex.printError();
      ex.printInfo();
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// Aksi saat button 'Kirim Ulang' ditekan
  Future<void> onPressedButtonKirimUlang({
    required String email,
    required int from,
    required dynamic data,
  }) async {
    // show button loading
    buttonState = AuthFilledButton.stateLoadingButton;

    await Future.delayed(const Duration(seconds: 3));

    DataState? dataState;

    // mengirim kode otp ke email
    switch (from) {
      case VerifyOtpPage.fromRegister:
        dataState = await _verifyController.requestOtp(
          email: email,
          type: VerificationController.registerVerify,
        );
      case VerifyOtpPage.fromLoginGoogle:
        dataState = await _verifyController.requestOtp(
          email: email,
          type: VerificationController.forgotVerify,
        );
      case VerifyOtpPage.fromForgotPin:
        dataState = await _verifyController.requestOtpByPhone(
          phone: data,
          type: VerificationController.forgotVerify,
        );
      default:
        Fluttertoast.showToast(msg: "default error");
    }

    // jika otp berhasil dikirim
    if (dataState is DataSuccess) {
      // close button loading
      _buttonState = AuthFilledButton.stateDisabledButton;

      // reset menit
      _second = 0;

      // menghitung ulang waktu
      _resent++;
      _calculateResendTime();

      _buildTimeStatus();

      notifyListeners();

      // membuka ulang halaman otp
      Get.offAll(
        VerifyOtpPage(
          verificationModel: dataState.data as VerificationModel,
          from: from,
          recipient: email,
          data: data,
        ),
        transition: Transition.noTransition,
      );
    }

    // jika otp gagal dikirim
    if (dataState is DataFailed) {
      PasarAjaUtils.triggerVibration();
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = dataState.error!.error ?? PasarAjaConstant.unknownError;
      notifyListeners();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// Timer kode otp
  ///
  Future<void> playTimer() async {
    DMethod.log('calling playtimer');
    while (_second >= 0) {
      if (_second == 0) {
        _buttonState = AuthFilledButton.stateEnabledButton;
        _timeStatus = 'Kirim Ulang OTP';
      } else {
        _buildTimeStatus();
      }

      DMethod.log('on while -> $_second');
      _second--;
      await Future.delayed(const Duration(seconds: 1));
      notifyListeners();
    }
  }

  /// Untuk menghitung limit waktu untuk mengirimkan ulang otp
  ///
  void _calculateResendTime() {
    switch (_resent) {
      case 1:
        _second = 20; // 2 menit
      case 2:
        _second = 30; // 3 menit
      case 3:
        _second = 50; // 5 menit
      case 4:
        _second = 70; // 7 menit
      case > 4:
        _second = 60; // 11 menit
    }
  }

  /// untuk mengenerate text sesuai dengan banyaknya waktu
  ///
  void _buildTimeStatus() {
    if (_second <= 59) {
      _timeStatus = 'Kirim Ulang OTP ($_second Detik)';
    } else if (_second >= 60 && _second <= 3600) {
      int menit = (_second ~/ 60).toInt();
      int detikSisa = _second % 60;
      _timeStatus =
          'Kirim Ulang OTP (${PasarAjaUtils.addZero(menit)}:${PasarAjaUtils.addZero(detikSisa)})';
    } else {
      int jam = (_second ~/ 3600).toInt();
      _timeStatus = "Kirim Ulang OTP ($jam Jam)";
    }
  }

  /// reset semua data pada provider
  void resetData() {
    _calculateResendTime();
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    vPin = PasarAjaValidation.pin('');
    notifyListeners();
  }

  /// reset data otp saat keluar dari page
  void onDispose() {
    DMethod.log("ON DISPOSE");
    _second = -1;
    _buildTimeStatus();
  }
}
