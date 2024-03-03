import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_third_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpCreatePage extends StatefulWidget {
  final String phone;
  const SignUpCreatePage({
    super.key,
    required this.phone,
  });

  @override
  State<SignUpCreatePage> createState() => _SignUpPageState(phone);
}

class _SignUpPageState extends State<SignUpCreatePage> {
  //
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController konfCont = TextEditingController();
  //
  ValidationModel vName = PasarAjaValidation.name(null);
  ValidationModel vPass = PasarAjaValidation.password(null);
  String? errKonf = null;
  //
  int state = AuthFilledButton.stateDisabledButton;
  bool obscurePass = false, obscureKonf = false;
  final String phone;
  //
  _SignUpPageState(this.phone);
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
                image: '',
                title: 'Daftar Akun',
                description:
                    'Silakan masukkan nama dan kata sandi untuk mendaftarkan akun.',
                haveImage: false,
              ),
              const SizedBox(height: 19),
              SingleChildScrollView(
                child: Column(
                  children: [
                    AuthInputText(
                      title: 'Masukan Nama',
                      textField: AuthTextField(
                        controller: nameCont,
                        hintText: 'Nama Anda',
                        fontSize: 20,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        errorText: vName.message,
                        onChanged: (value) {
                          vName = PasarAjaValidation.name(value);
                          // upate state
                          state = _buttonState(
                            vName.status,
                            vPass.status,
                            errKonf != null,
                          );
                          setState(() {});
                        },
                        suffixAction: () {
                          nameCont.text = '';
                          vName = PasarAjaValidation.name('');
                          // update state
                          state = _buttonState(
                            vName.status,
                            vPass.status,
                            errKonf != null,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    AuthInputText(
                      title: 'Masukan Kata Sandi',
                      textField: AuthTextField(
                        controller: pwCont,
                        hintText: 'xxxxxxxx',
                        fontSize: 20,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        obscureText: obscurePass,
                        errorText: vPass.message,
                        suffixIcon: obscurePass
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              ),
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
                            vName.status,
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
                        errorText: errKonf,
                        fontSize: 20,
                        obscureText: obscureKonf,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        suffixIcon: AuthTextField.hiddenPassword(obscureKonf),
                        onChanged: (value) {
                          // check apakah password cocok atau tidak
                          if (value != pwCont.text) {
                            errKonf = 'Konfirmasi password tidak cocok';
                          } else {
                            errKonf = null;
                          }
                          // update state
                          state = _buttonState(
                            vName.status,
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
                    ),
                    const SizedBox(height: 40),
                    AuthFilledButton(
                      onPressed: () async {
                        setState(
                          () => state = AuthFilledButton.stateLoadingButton,
                        );
                        await Future.delayed(
                          const Duration(seconds: PasarAjaConstant.initLoading),
                        );
                        setState(
                          () => state = AuthFilledButton.stateEnabledButton,
                        );
                        Get.to(
                          SingUpCreatePin(
                            user: UserModel(
                              phoneNumber: phone,
                              fullName: nameCont.text,
                              password: pwCont.text,
                            ),
                          ),
                        );
                      },
                      state: state,
                      title: 'Berikutnya',
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

int _buttonState(bool? v1, bool? v2, bool? v3) {
  if (v1 == null || v2 == null || v3 == null) {
    return AuthFilledButton.stateDisabledButton;
  }
  if (!v1 || !v2 || v3) {
    return AuthFilledButton.stateDisabledButton;
  } else {
    return AuthFilledButton.stateEnabledButton;
  }
}
