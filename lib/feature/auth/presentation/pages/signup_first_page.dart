import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constant/constants.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/countries.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/helper_text.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/input_title.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/textfield.dart';

class SignUpPhonePage extends StatefulWidget {
  const SignUpPhonePage({super.key});

  @override
  State<SignUpPhonePage> createState() => _SignUpPhonePageState();
}

class _SignUpPhonePageState extends State<SignUpPhonePage> {
  final TextEditingController nohpCont = TextEditingController();
  int state = AuthFilledButton.stateEnabledButton;
  bool isError = false;
  ValidationModel validate = PasarAjaValidation.phone('');
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
                image: PasarAjaImage.ilLoginPhone,
                title: 'Daftar Akun',
                description:
                    'Silakan masukkan nomor HP Anda untuk mendaftar akun pada Aplikasi.',
              ),
              const SizedBox(height: 19),
              const Align(
                alignment: Alignment.centerLeft,
                child: AuthInputTitle(title: 'Masukan Nomor HP'),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    const Expanded(child: AuthCountries()),
                    const SizedBox(width: 13),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: AuthTextField(
                        controller: nohpCont,
                        hintText: '82-xxxx-xxxx',
                        errorText: validate.message,
                        keyboardType: TextInputType.number,
                        formatters: AuthTextField.numberFormatter(),
                        isError: validate.status,
                        suffixAction: () {
                          setState(() => nohpCont.text = '');
                        },
                        onChanged: (value) {
                          validate = PasarAjaValidation.phone(value);
                          if (validate.status == false) {
                            setState(() =>
                                state = AuthFilledButton.stateDisabledButton);
                          } else {
                            setState(() =>
                                state = AuthFilledButton.stateEnabledButton);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AuthHelperText(
                  title: validate.message,
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () async {
                  setState(() => state = AuthFilledButton.stateLoadingButton);
                  await Future.delayed(
                    const Duration(seconds: PasarAjaConstant.initLoading),
                  );
                  setState(() => state = AuthFilledButton.stateEnabledButton);
                  Navigator.pushNamed(context, RouteName.verifyCode);
                },
                state: state,
                title: 'Berikutnya',
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
