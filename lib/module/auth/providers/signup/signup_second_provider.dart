import 'package:d_method/d_method.dart';
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
import 'package:pasaraja_mobile/module/auth/views/signup/signup_third_page.dart';
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

  /// login google
  bool _isLoginGoogle = false;
  bool get isLoginGoogle => _isLoginGoogle;
  set isLoginGoogle(bool a) {
    _isLoginGoogle = a;
    notifyListeners();
  }

  /// Untuk mengecek apakah email yang diinputkan valid atau tidak
  ///
  void onValidateEmail(String email) {
    // mengecek email valid atau tidak
    vEmail = PasarAjaValidation.email(email);

    // jika email valid
    if (vEmail.status == true) {
      _message = '';
    } else {
      _message = vEmail.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  /// Untuk mengecek apakah nama yang diinputkan valid atau tidak
  ///
  void onValidateName(String nama) {
    // mengecek nama valid atau tidak
    vName = PasarAjaValidation.name(nama);

    // jika nama valid
    if (vName.status == true) {
      _message = '';
    } else {
      _message = vName.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Untuk mengecek apakah password yang diinputkan valid atau tidak
  ///
  void onValidatePassword(String password, String konf) {
    // mengecek password valid atau tidak
    vPass = PasarAjaValidation.password(password);

    // jika password valid atau tidak
    if (vPass.status == true) {
      _message = '';
      onValidateKonf(password, konf);
    } else {
      _message = vPass.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Untuk mengecek apakah konfirmasi password cocok atau tidak
  ///
  void onValidateKonf(String password, String konf) {
    // mengecek konfirmasi password cocok atau tidak
    vKonf = PasarAjaValidation.konfirmasiPassword(password, konf);

    // jika konfirmasi password cocok
    if (vKonf.status == true) {
      _message = '';
    } else {
      _message = vKonf.message ?? PasarAjaConstant.unknownError;
    }

    // update status button
    _updateButonState();
  }

  /// Enable & disable button, sesuai dengan valid atau tidaknya data
  ///
  void _updateButonState() {
    if (vEmail.status == null ||
        vName.status == null ||
        vPass.status == null ||
        vKonf.status == null) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vEmail.status == false ||
        vName.status == false ||
        vPass.status == false ||
        vKonf.status == false) {
      _buttonState = AuthFilledButton.stateDisabledButton;
    } else {
      _buttonState = AuthFilledButton.stateEnabledButton;
    }
    notifyListeners();
  }

  /// Aksi saat button 'Berikutnya' ditekan
  Future<void> onPressedButtonBerikutnya({
    required String phone,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      // show buton loading
      buttonState = AuthFilledButton.stateLoadingButton;

      await PasarAjaConstant.buttonDelay;

      // memanggil controller untuk untuk mengecek apakah email sudah terdaftar atau belum
      DataState dataState = await _authController.isExistEmail(
        email: email,
      );

      DMethod.log('email : ${email}');

      // jika email sudah terdaftar
      if (dataState is DataSuccess) {
        PasarAjaMessage.showSnackbarWarning("Email tersebut sudah terdaftar");
        // reset data email
        PasarAjaUtils.triggerVibration();
        emailCont.text = '';
        onValidateEmail('');
        // close loading button
        buttonState = AuthFilledButton.stateDisabledButton;
      }

      // jika email belum terdaftar
      if (dataState is DataFailed) {
        // close loading button
        buttonState = AuthFilledButton.stateEnabledButton;

        // jika login dari google
        if (isLoginGoogle) {
          // membuka halaman register 3
          Get.off(
            SignUpThirdPage(
              user: UserModel(
                phoneNumber: phone,
                email: email,
                fullName: fullName,
                password: password,
              ),
            ),
            transition: Transition.leftToRight,
            duration: PasarAjaConstant.transitionDuration,
          );
        } else {
          // menampilkan konfirmasi dialog untuk mengirimkan kode otp
          final bool confirm = await PasarAjaMessage.showConfirmation(
            "Kami akan mengirimkan kode OTP ke email Anda",
            actionYes: 'Kirim',
            actionCancel: 'Batal',
          );

          // jika user menekan tombol yes
          if (confirm) {
            // menampilkan loading ui
            PasarAjaMessage.showLoading();

            // memanggil controller untuk mengirimkan otp ke alamat email user
            dataState = await _verifyController.requestOtp(
              email: email,
              type: VerificationController.registerVerify,
            );

            // close loading ui
            Get.back();

            // otp berhasil terikirm
            if (dataState is DataSuccess) {
              // membuka halaman verifikasi otp dengan membawa data otp dan user
              Get.to(
                VerifyOtpPage(
                  verificationModel:
                      dataState.data as VerificationModel, // data otp
                  from: VerifyOtpPage.fromRegister,
                  recipient: email,
                  data: UserModel(
                    // data user
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
              _buttonState = AuthFilledButton.stateEnabledButton;
              notifyListeners();
              Fluttertoast.showToast(msg: message.toString());
            }
          }
        }
      }
    } catch (ex) {
      _buttonState = AuthFilledButton.stateEnabledButton;
      _message = ex.toString();
      notifyListeners();
      Fluttertoast.showToast(msg: message.toString());
    }
  }

  /// Aksi saat button 'Google' ditekan
  Future<void> onTapButtonGoogle({
    required GoogleSignInAccount user,
  }) async {
    try {
      // jika user tidak memilih akun apapun
      if (user.email.isEmpty) {
        return;
      }

      // show confirm dialog
      final confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda yakin ingin menggunakan akun '${user.email}' sebagai alamat email Anda?\n\n Note : Alamat email tidak bisa diubah! ",
        actionYes: 'Pakai',
        actionCancel: 'Batal',
        barrierDismissible: false,
      );

      if (confirm) {
        // show loading ui
        PasarAjaMessage.showLoading();

        await Future.delayed(const Duration(seconds: 3));

        // memanggil controller untuk mengecek apakah email yang dipilih exist atau tidak
        final dataState = await _authController.isExistEmail(
          email: user.email,
        );

        // close loading ui
        Get.back();

        // jika email sudah terdaftar
        if (dataState is DataSuccess) {
          PasarAjaMessage.showSnackbarWarning("Email tersebut sudah terdaftar");
          // reset data email dan nama
          PasarAjaUtils.triggerVibration();
          emailCont.text = '';
          nameCont.text = '';
          onValidateEmail('');
          onValidateName('');
        }

        // jika email belum terdaftar
        if (dataState is DataFailed) {
          // update status login
          isLoginGoogle = true;
          // mendapatkan data user
          final email = user.email;
          final name = user.displayName ?? '';
          // show data
          emailCont.text = email;
          nameCont.text = name;
          // validasi data
          onValidateEmail(email);
          onValidateName(name);
        }
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
    _buttonState = AuthFilledButton.stateDisabledButton;
    _message = '';
    _isLoginGoogle = false;
    _obscurePass = true;
    _obscureKonf = true;
    vEmail = PasarAjaValidation.email(null);
    vName = PasarAjaValidation.name(null);
    vPass = PasarAjaValidation.password(null);
    vKonf = PasarAjaValidation.konfirmasiPassword(null, null);
    notifyListeners();
  }
}
