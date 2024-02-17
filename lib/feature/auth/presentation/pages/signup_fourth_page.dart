import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';

class SignUpConfirmPage extends StatefulWidget {
  const SignUpConfirmPage({super.key});

  @override
  State<SignUpConfirmPage> createState() => _SignUpConfirmPageState();
}

class _SignUpConfirmPageState extends State<SignUpConfirmPage> {
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
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [],
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () {},
                title: 'Buat Akun',
              )
            ],
          ),
        ),
      ),
    );
  }
}
