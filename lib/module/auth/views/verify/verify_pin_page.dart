import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/data/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/controllers/signin_controller.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class VerifyPinPage extends StatefulWidget {
  final String phone;
  const VerifyPinPage({
    super.key,
    required this.phone,
  });

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState(phone);
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  final SignInController _signInController = SignInController();
  //
  ValidationModel vPin = PasarAjaValidation.pin(null);
  //
  final String phone;
  int state = AuthFilledButton.stateDisabledButton;
  String? errMessage;
  //
  _VerifyPinPageState(this.phone);
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
                title: 'Masukan PIN',
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
                          onChanged: (value) {
                            setState(() => errMessage = null);
                          },
                          onCompleted: (value) async {
                            // send request to login
                            DataState dataState =
                                await _signInController.signInPhone(
                              phone: "62$phone",
                              pin: value,
                            );

                            if (dataState is DataSuccess) {
                              Fluttertoast.showToast(msg: "Login Berhasil");
                            }

                            if (dataState is DataFailed) {
                              PasarAjaUtils.triggerVibration();
                              errMessage = dataState.error!.message;
                              Fluttertoast.showToast(
                                  msg: dataState.error!.message);
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
