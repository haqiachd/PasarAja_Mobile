import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_input_pin.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/pin_view.dart';

class SingUpCreatePin extends StatefulWidget {
  const SingUpCreatePin({super.key});

  @override
  State<SingUpCreatePin> createState() => _SingUpCreatePinState();
}

class _SingUpCreatePinState extends State<SingUpCreatePin> {
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
                image: PasarAjaImage.ilNewPin,
                title: 'Buat PIN Baru',
                description:
                    'Buatlah PIN yang kuat dan jangan bagikan PIN Anda kepada orang lain.',
              ),
              const SizedBox(
                height: 19,
              ),
              const Column(
                children: [
                  AuthInputPin(
                    title: 'Masukan PIN',
                    authPin: AuthPin(
                      length: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.signupFourth);
                },
                title: 'Berikutnya',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
