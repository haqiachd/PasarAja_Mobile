import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';

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
                image: PasarAjaImage.ilInputPin,
                title: 'Buat PIN Baru',
                description:
                    'Buatlah PIN yang kuat dan jangan bagikan PIN Anda kepada orang lain.',
              ),
              const SizedBox(
                height: 19,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.signupFourth);
                },
                title: 'Berikutnya',
              )
            ],
          ),
        ),
      ),
    );
  }
}
