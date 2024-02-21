import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_input_text.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/textfield.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  TextEditingController pinCont = TextEditingController();
  TextEditingController konfCont = TextEditingController();
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
            top: 94 - MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilCreate,
                title: 'Ganti PIN',
                description:
                    'Buatlah PIN yang kuat dan jangan bagikan PIN Anda kepada orang lain.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 140),
                child: Column(
                  children: [
                    AuthInputText(
                      title: 'Masukan PIN',
                      textField: AuthTextField(
                        controller: pinCont,
                        hintText: 'xxxxxxx',
                      ),
                    ),
                    const SizedBox(height: 12),
                    AuthInputText(
                      title: 'Konfirmasi PIN',
                      textField: AuthTextField(
                        controller: konfCont,
                        hintText: 'xxxxxxx',
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.changePw);
                  },
                  state: state,
                  title: 'Ganti PIN')
            ],
          ),
        ),
      ),
    );
  }
}
