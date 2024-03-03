import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signin_google_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController konfCont = TextEditingController();
  //
  ValidationModel vPass = PasarAjaValidation.password(null);
  ValidationModel vKonf = PasarAjaValidation.password(null);
  //
  int state = AuthFilledButton.stateDisabledButton;
  bool obscurePass = true, obscureKonf = true;
  String? errKonf;
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password berhasil diganti"),
                    ),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  Get.off(
                    const SignInGooglePage(),
                    transition: Transition.downToUp,
                  );
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
