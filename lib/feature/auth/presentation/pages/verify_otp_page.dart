import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
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
                image: PasarAjaImage.icNumber,
                title: 'Verifikasi OTP',
                description:
                    'Silakan masukkan kode OTP yang telah kami kirimkan ke nomor HP Anda.',
              ),
              const SizedBox(height: 19),
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [],
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.signupSecond);
                },
                title: 'Kirim Ulang',
              )
            ],
          ),
        ),
      ),
    );
  }
}
