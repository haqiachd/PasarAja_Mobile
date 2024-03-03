import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SignUpConfirmPage extends StatefulWidget {
  final String? createdPin;
  const SignUpConfirmPage({super.key, this.createdPin});

  @override
  State<SignUpConfirmPage> createState() => _SignUpConfirmPageState(createdPin);
}

class _SignUpConfirmPageState extends State<SignUpConfirmPage> {
  int state = AuthFilledButton.stateDisabledButton;
  ValidationModel vPin = PasarAjaValidation.pin(null);
  String? errMessage;
  final String? createdPin;
  bool isMatch = false;
  _SignUpConfirmPageState(this.createdPin);
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
                  print(createdPin);
                  // setState(
                  //   () => state = AuthFilledButton.stateLoadingButton,
                  // );
                  // await Future.delayed(
                  //   const Duration(seconds: PasarAjaConstant.initLoading),
                  // );
                  // setState(
                  //   () => state = AuthFilledButton.stateEnabledButton,
                  // );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('Sudah sampai disini saja.'),
                  //   ),
                  // );
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
