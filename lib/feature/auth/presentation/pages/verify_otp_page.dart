import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constant/constants.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/change_password_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/pages/signup_second_page.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/widgets.dart';

class VerifyOtpPage extends StatefulWidget {
  static const int fromLoginGoogle = 1;
  static const int fromRegister = 2;
  //
  final int? from;
  const VerifyOtpPage({
    super.key,
    this.from,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState(from: from);
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  int state = AuthFilledButton.stateDisabledButton;
  String otp = '2602';
  String? errMessage;
  final int? from;

  _VerifyOtpPageState({this.from});
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
            top: 176 - MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilVerifyOtp,
                title: 'Verifikasi OTP',
                description:
                    'Silakan masukkan kode OTP yang telah kami kirimkan ke nomor HP Anda.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AuthInputPin(
                        title: 'Masukan OTP',
                        authPin: AuthPin(
                          length: 4,
                          onChanged: (value) {
                            errMessage = null;
                            setState(() {});
                          },
                          onCompleted: (value) async {
                            if (value == otp) {
                              await Future.delayed(const Duration(seconds: 1));
                              switch (from) {
                                case VerifyOtpPage.fromLoginGoogle:
                                  Get.off(
                                    const ChangePasswordPage(),
                                    transition: Transition.leftToRight,
                                  );
                                case VerifyOtpPage.fromRegister:
                                  Get.off(
                                    const SignUpCreatePage(),
                                    transition: Transition.leftToRight,
                                  );
                                default:
                                  print('anjing');
                              }
                            } else {
                              errMessage = 'Kode OTP tidak cocok!';
                              PasarAjaUtils.triggerVibration();
                            }
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
              const SizedBox(height: 30),
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
                  Navigator.pushNamed(context, RouteName.signupSecond);
                },
                state: state,
                title: 'Kirim Ulang (3 menit)',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
