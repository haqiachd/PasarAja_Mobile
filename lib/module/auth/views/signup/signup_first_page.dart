import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/data/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';
import 'package:pasaraja_mobile/module/auth/views/verify/verify_otp_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpPhonePage extends StatefulWidget {
  const SignUpPhonePage({super.key});

  @override
  State<SignUpPhonePage> createState() => _SignUpPhonePageState();
}

class _SignUpPhonePageState extends State<SignUpPhonePage> {
  final AuthController _authController = AuthController();
  //
  final TextEditingController nohpCont = TextEditingController();
  ValidationModel vPhone = PasarAjaValidation.phone(null);
  //
  int state = AuthFilledButton.stateDisabledButton;
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
                image: PasarAjaImage.ilLoginPhone,
                title: 'Daftar Akun',
                description:
                    'Silakan masukkan nomor HP Anda untuk mendaftar akun pada Aplikasi.',
              ),
              const SizedBox(height: 19),
              const Align(
                alignment: Alignment.centerLeft,
                child: AuthInputTitle(title: 'Masukan Nomor HP'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    const Expanded(child: AuthCountries()),
                    const SizedBox(width: 13),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: AuthTextField(
                        controller: nohpCont,
                        hintText: '82-xxxx-xxxx',
                        errorText: vPhone.message,
                        keyboardType: TextInputType.number,
                        showHelper: false,
                        formatters: AuthTextField.numberFormatter(),
                        onChanged: (value) {
                          // valdasi data
                          vPhone = PasarAjaValidation.phone(value);
                          // enable and disable button
                          if (vPhone.status == true) {
                            state = AuthFilledButton.stateEnabledButton;
                            nohpCont.text = value;
                          } else {
                            state = AuthFilledButton.stateDisabledButton;
                          }
                          setState(() {});
                        },
                        suffixAction: () {
                          setState(() => nohpCont.text = '');
                          setState(
                            () => state = AuthFilledButton.stateDisabledButton,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AuthHelperText(
                  title: _showHelperText(vPhone.message),
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () async {
                  setState(() => state = AuthFilledButton.stateLoadingButton);

                  DataState dataState = await _authController.isExistPhone(
                    phone: "62${nohpCont.text}",
                  );

                  if (dataState is DataSuccess) {
                    if (dataState.data == true) {
                      PasarAjaUtils.triggerVibration();
                      Fluttertoast.showToast(msg: "Nomor hp sudah terdaftar");
                    } else {
                      Get.to(
                        VerifyOtpPage(
                          verificationModel:
                              const VerificationModel(otp: "1234"),
                          from: VerifyOtpPage.fromRegister,
                          recipient: "62${nohpCont.text}",
                        ),
                        transition: Transition.leftToRight,
                        duration: const Duration(milliseconds: 500),
                      );
                    }
                  }

                  if (dataState is DataFailed) {
                    Fluttertoast.showToast(msg: dataState.error!.message);
                  }

                  setState(() => state = AuthFilledButton.stateEnabledButton);
                },
                state: state,
                title: 'Berikutnya',
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

String? _showHelperText(String? message) {
  if (message == null || message != 'Phone null' && message != 'Data valid') {
    return message;
  } else {
    return null;
  }
}
