import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/change_controller.dart';
import 'package:pasaraja_mobile/module/auth/views/signin/signin_google_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;
  const ChangePasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState(email);
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ChangeController _changeController = ChangeController();
  //
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController konfCont = TextEditingController();
  //
  ValidationModel vPass = PasarAjaValidation.password(null);
  ValidationModel vKonf = PasarAjaValidation.password(null);
  //
  int state = AuthFilledButton.stateDisabledButton;
  bool obscurePass = true, obscureKonf = true;
  String? errKonf;
  final String email;
  //
  _ChangePasswordPageState(this.email);
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
            top: 94 - MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilCreate,
                title: 'Ganti Kata Sandi',
                description:
                    'Buatlah sebuah kata sandi yang rumit dan sulit ditebak oleh orang lain.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    AuthInputText(
                      title: 'Masukan Kata Sandi',
                      textField: AuthTextField(
                        controller: pwCont,
                        hintText: 'xxxxxxxx',
                        obscureText: obscurePass,
                        fontSize: 20,
                        errorText: vPass.message,
                        suffixIcon: AuthTextField.hiddenPassword(obscurePass),
                        onChanged: (value) {
                          vPass = PasarAjaValidation.password(value);
                          // check apakah password cocok atau tidak
                          if (vPass.status == true) {
                            if (value != konfCont.text) {
                              errKonf = 'Konfirmasi password tidak cocok';
                            } else {
                              errKonf = null;
                            }
                          }
                          // update state button
                          state = _buttonState(
                            vPass.status,
                            errKonf != null,
                          );
                          setState(() {});
                        },
                        suffixAction: () {
                          obscurePass = !obscurePass;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    AuthInputText(
                      title: 'Konfirmasi Kata Sandi',
                      textField: AuthTextField(
                        controller: konfCont,
                        hintText: 'xxxxxxxx',
                        obscureText: obscureKonf,
                        fontSize: 20,
                        errorText: errKonf,
                        suffixIcon: AuthTextField.hiddenPassword(obscureKonf),
                        onChanged: (value) {
                          // check apakah password cocok atau tidak
                          if (value != pwCont.text) {
                            errKonf = 'Konfirmasi password tidak cocok';
                          } else {
                            errKonf = null;
                          }
                          // update state button
                          state = _buttonState(
                            vPass.status,
                            errKonf != null,
                          );
                          setState(() {});
                        },
                        suffixAction: () {
                          obscureKonf = !obscureKonf;
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () async {
                  setState(() => state = AuthFilledButton.stateLoadingButton);

                  final DataState dataState =
                      await _changeController.changePassword(
                    email: email,
                    password: pwCont.text,
                  );

                  if (dataState is DataSuccess) {
                    Get.off(
                      const SignInGooglePage(),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 500),
                    );
                  }

                  if (dataState is DataFailed) {
                    Fluttertoast.showToast(
                      msg: dataState.error!.message ??
                          PasarAjaConstant.unknownError,
                    );
                  }

                  setState(() => state = AuthFilledButton.stateEnabledButton);
                },
                state: state,
                title: 'Ganti Kata Sandi',
              ),
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
  if (!v1 || v2) {
    return AuthFilledButton.stateDisabledButton;
  } else {
    return AuthFilledButton.stateEnabledButton;
  }
}
