import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_input_text.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/textfield.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController konfCont = TextEditingController();
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
                title: 'Ganti Kata Sandi',
                description:
                    'Buatlah sebuah kata sandi yang rumit dan sulit ditebak oleh orang lain.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    AuthInputText(
                      title: 'Masukan Kata Sandi',
                      textField: AuthTextField(
                        controller: pwCont,
                        hintText: 'xxxxxxxx',
                      ),
                    ),
                    const SizedBox(height: 12),
                    AuthInputText(
                      title: 'Konfirmasi Kata Sandi',
                      textField: AuthTextField(
                        controller: konfCont,
                        hintText: 'xxxxxxxx',
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () {},
                state: state,
                title: 'Ganti Kata Sandi',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
