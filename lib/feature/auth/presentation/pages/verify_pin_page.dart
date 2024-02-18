import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constant/constants.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_input_pin.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/pin_view.dart';

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
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: AuthInputPin(
                  title: 'Masukan PIN',
                  authPin: AuthPin(
                    length: 6,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
