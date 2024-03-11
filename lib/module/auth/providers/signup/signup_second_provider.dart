import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_third_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpSecondProvider extends ChangeNotifier {
  // controller, validator
  ValidationModel vName = PasarAjaValidation.name(null);
  ValidationModel vPass = PasarAjaValidation.password(null);
  ValidationModel vKonf = PasarAjaValidation.konfirmasiPassword(null, null);
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController konfCont = TextEditingController();

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
  void onValidatePassword(String password) {
    vPass = PasarAjaValidation.password(password);

    // enable and disable button
    if (vPass.status == true) {
      message = '';
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
    if (vName.status == null || vPass.status == null || vKonf.status == null) {
      buttonState = AuthFilledButton.stateDisabledButton;
    }
    if (vName.status == false ||
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
    required String fullName,
    required String password,
  }) async {
    try {
      Get.to(
        SingUpCreatePin(
          user: UserModel(
            phoneNumber: phone,
            fullName: fullName,
            password: password,
          ),
        ),
      );
    } catch (ex) {
      buttonState = AuthFilledButton.stateEnabledButton;
      message = ex.toString();
      Fluttertoast.showToast(msg: message.toString());
      notifyListeners();
    }
  }

  /// reset semua data pada provider
  void resetData() {
    nameCont.text = '';
    pwCont.text = '';
    konfCont.text = '';
    buttonState = AuthFilledButton.stateDisabledButton;
    message = '';
    obscurePass = false;
    obscureKonf = false;
    vName = PasarAjaValidation.name('');
    vPass = PasarAjaValidation.password('');
    notifyListeners();
  }
}
