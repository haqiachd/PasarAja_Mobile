import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constant/constants.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:otp_text_field/otp_field.dart';

class VerifyPinPage extends StatefulWidget {
  const VerifyPinPage({super.key});

  @override
  State<VerifyPinPage> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPinPage> {
  OtpFieldController otpCont = OtpFieldController();
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
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: OTPTextField(
                  controller: otpCont,
                  isDense: true,
                  length: 4, // Set the length to 6 for a 6-digit OTP
                  width: MediaQuery.of(context).size.width,
                  obscureText: false,
                  textFieldAlignment: MainAxisAlignment.center,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                  ),
                  style: PasarAjaTypography.sfpdBold,
                  fieldStyle: FieldStyle.box,
                  fieldWidth: 50,
                  spaceBetween: 5,
                  onCompleted: (pin) {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
