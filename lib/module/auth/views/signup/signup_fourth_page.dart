import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signup_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpConfirmPage extends StatefulWidget {
  final UserModel user;
  final String createdPin;
  const SignUpConfirmPage({
    super.key,
    required this.user,
    required this.createdPin,
  });

  @override
  State<SignUpConfirmPage> createState() =>
      _SignUpConfirmPageState(user, createdPin);
}

class _SignUpConfirmPageState extends State<SignUpConfirmPage> {
  //
  final SignUpController _signUpController = SignUpController();
  ValidationModel vPin = PasarAjaValidation.pin(null);
  //
  bool isMatch = false;
  String? errMessage;
  int state = AuthFilledButton.stateDisabledButton;
  final UserModel user;
  final String createdPin;
  //
  _SignUpConfirmPageState(this.user, this.createdPin);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: authAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 19,
              right: 19,
              top: 176 - MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilConfirmPin,
                title: 'Konfirmasi PIN',
                description:
                    'Ketik ulang PIN Anda untuk memverifikasi pembuatan PIN.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    AuthInputPin(
                      title: 'Masukan PIN',
                      authPin: AuthPin(
                        length: 6,
                        onChanged: (value) {
                          vPin = PasarAjaValidation.pin(value);
                          state = _buttonState(vPin.status, false);
                          errMessage = null;
                          setState(() {});
                        },
                        onCompleted: (value) {
                          vPin = PasarAjaValidation.pin(value);
                          state = _buttonState(vPin.status, isMatch);
                          if (createdPin == value) {
                            isMatch = true;
                          } else {
                            isMatch = false;
                            errMessage = 'PIN tidak cocok';
                          }
                          state = _buttonState(vPin.status, isMatch);
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: AuthHelperText(
                  title: errMessage,
                ),
              ),
              const SizedBox(height: 30),
              AuthFilledButton(
                onPressed: () async {
                  // Fluttertoast.showToast(
                  //   msg:
                  //       "phone : ${user.phoneNumber} | name : ${user.fullName} | password ${user.password} | pin $createdPin",
                  // );

                  DataState dataState = await _signUpController.signUp(
                    phone: user.phoneNumber!,
                    fullName: user.fullName!,
                    pin: createdPin,
                    password: user.password!,
                  );

                  if (dataState is DataSuccess) {
                    Fluttertoast.showToast(
                      msg:
                          "Register berhasil, Silahkan login dengan akun yang baru",
                    );

                    await Future.delayed(const Duration(seconds: 2));

                    Get.off(
                      const WelcomePage(),
                      transition: Transition.leftToRight,
                    );
                  }

                  if (dataState is DataFailed) {
                    PasarAjaUtils.triggerVibration();
                    Fluttertoast.showToast(msg: dataState.error!.message);
                  }
                },
                state: state,
                title: 'Buat Akun',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

int _buttonState(bool? v1, bool? v2) {
  if (v1 == null || v2 == null) {
    return AuthFilledButton.stateDisabledButton;
  }

  if (v1 == true && v2 == true) {
    return AuthFilledButton.stateEnabledButton;
  } else {
    return AuthFilledButton.stateDisabledButton;
  }
}
