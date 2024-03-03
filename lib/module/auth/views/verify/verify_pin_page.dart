import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class VerifyPinPage extends StatefulWidget {
  const VerifyPinPage({super.key});

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  int state = AuthFilledButton.stateDisabledButton;
  ValidationModel vPin = PasarAjaValidation.pin(null);
  String pin = '123456';
  String? errMessage;
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
            top: 176 -
                (MediaQuery.of(context).padding.top +
                    PasarAjaConstant.authTolbarHeight),
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilInputPin,
                title: 'Masukan PIN (remote)',
                description:
                    'Silakan masukkan PIN Anda untuk memverifikasi identitas Anda.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AuthInputPin(
                        title: 'Masukan PIN',
                        authPin: AuthPin(
                          length: 6,
                          onCompleted: (value) async {
                            if (value != pin) {
                              errMessage = 'PIN tidak cocok';
                            } else {
                              errMessage = null;
                              await Future.delayed(
                                const Duration(microseconds: 500),
                              );
                              _showMyDialog(
                                context,
                                'Informasi',
                                'Login Berhasil',
                              );
                            }
                            setState(() {});
                          },
                        ),
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
              const SizedBox(height: 40),
              Visibility(
                visible: false,
                child: AuthFilledButton(
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sudah sampai disini saja.'),
                      ),
                    );
                  },
                  state: state,
                  title: 'Masuk',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _onLoginSuccess(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 500));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Login Berhasil'),
    ),
  );
}

Future<void> _showMyDialog(
    BuildContext context, String title, String content) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: PasarAjaTypography.sfpdBold,
        ),
        content: Text(
          content,
          style: PasarAjaTypography.sfpdSemibold,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
