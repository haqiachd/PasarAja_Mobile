import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_input_text.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/textfield.dart';

class SignUpCreatePage extends StatefulWidget {
  const SignUpCreatePage({super.key});

  @override
  State<SignUpCreatePage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpCreatePage> {
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController pwCont = TextEditingController();
  final TextEditingController konfCont = TextEditingController();
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
                image: '',
                title: 'Daftar Akun',
                description:
                    'Silakan masukkan nama dan kata sandi untuk mendaftarkan akun.',
                haveImage: false,
              ),
              const SizedBox(height: 19),
              SingleChildScrollView(
                child: Column(
                  children: [
                    AuthInputText(
                      title: 'Masukan Nama',
                      textField: AuthTextField(
                        controller: emailCont,
                        hintText: 'Nama Anda',
                      ),
                    ),
                    const SizedBox(height: 12),
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
                    ),
                    const SizedBox(height: 40),
                    AuthFilledButton(
                      onPressed: () {},
                      title: 'Berikutnya',
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
