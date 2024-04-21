import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';

class EditAccountCustomerProvider extends ChangeNotifier{
  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  ValidationModel vName = PasarAjaValidation.name(null);

  final _controller = AuthController();
  ProviderState state = const OnInitState();

  String _email = '';
  String get email => _email;

  String _fullName = '';
  String get fullName => _fullName;

  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  int _buttonState = ActionButton.stateDisabledButton;
  int get buttonState => _buttonState;
  set buttonState(int n) {
    _buttonState = n;
    notifyListeners();
  }

  Object _message = '';

  Object get message => _message;

  set message(Object m) {
    _message = m;
    notifyListeners();
  }

  /// Untuk mengecek apakah nama yang diinputkan valid atau tidak
  ///
  void onValidateName(String email) {
    // mengecek nama valid atau tidak
    vName = PasarAjaValidation.name(email);

    // jika nama valid
    if (vName.status == true) {
      _message = '';
    } else {
      _message = vName.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  void _updateButonState() {
    if (vName.status == null) {
      _buttonState = ActionButton.stateDisabledButton;
    }
    if (vName.status == false) {
      _buttonState = ActionButton.stateDisabledButton;
    } else {
      _buttonState = ActionButton.stateEnabledButton;
    }
    notifyListeners();
  }

  Future<void> setData({
    required String email,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      state = const OnLoadingState();
      notifyListeners();

      // get data
      _email = email;
      _fullName = fullName;
      _phoneNumber = phoneNumber;

      // update controller
      emailCont = TextEditingController(text: _email);
      nameCont = TextEditingController(text: _fullName);
      phoneCont = TextEditingController(text: _phoneNumber);

      // update validation
      onValidateName(_fullName);

      state = const OnSuccessState();
      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> updateAccount() async {
    try {
      PasarAjaMessage.showLoading();

      // call controller
      final dataState = await _controller.updateAccount(
        email: _email,
        fullName: nameCont.text,
      );

      if (dataState is DataSuccess) {
        Get.back();
        await PasarAjaMessage.showInformation("Akun Berhasil Diupdate");

        // get data model
        UserModel userModel = dataState.data as UserModel;

        // update data di preferences
        await PasarAjaUserService.setUserData(
          PasarAjaUserService.fullName,
          userModel.fullName,
        );

        Get.back();
      }

      if (dataState is DataFailed) {
        Get.back();
        await PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      Get.back();
      await PasarAjaMessage.showSnackbarWarning(
        ex.toString(),
      );
    }
  }
}