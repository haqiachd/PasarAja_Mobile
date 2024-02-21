import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_input_pin.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/pin_view.dart';

class SignUpConfirmPage extends StatefulWidget {
  const SignUpConfirmPage({super.key});

  @override
  State<SignUpConfirmPage> createState() => _SignUpConfirmPageState();
}

class _SignUpConfirmPageState extends State<SignUpConfirmPage> {
  int state = AuthFilledButton.stateEnabledButton;
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
                  children: [
                    AuthInputPin(
                      title: 'Masukan PIN',
                      authPin: AuthPin(
                        length: 6,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sudah sampai disini saja.'),
                    ),
                  );
                },
                state: state,
                title: 'Buat Akun',
              )
            ],
          ),
        ),
      ),
    );
  }
}
