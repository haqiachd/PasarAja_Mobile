import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constant/constants.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/appbar.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_input_text.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/textfield.dart';

class SignInGooglePage extends StatefulWidget {
  const SignInGooglePage({super.key});

  @override
  State<SignInGooglePage> createState() => _SignInGooglePageState();
}

class _SignInGooglePageState extends State<SignInGooglePage> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController pwCont = TextEditingController();
  ValidationModel vEmail = PasarAjaValidation.email(null);
  //
  int state = AuthFilledButton.stateEnabledButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: authAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 70 - MediaQuery.of(context).padding.top,
            left: 19,
            right: 19,
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilLoginEmail,
                title: 'Masuk Akun',
                haveImage: false,
                description:
                    'Silakan masukkan email dan kata sandi Anda untuk masuk ke dalam aplikasi.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    AuthInputText(
                      title: 'Masukan Email',
                      textField: AuthTextField(
                        controller: emailCont,
                        hintText: 'pasaraja@email.com',
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        fontSize: 18,
                        isError: vEmail.status,
                        errorText: vEmail.message,
                        onChanged: (value) {
                          setState(
                            () {
                              vEmail = PasarAjaValidation.email(value);
                            },
                          );
                        },
                        suffixAction: () {
                          setState(() {
                            emailCont.text = '';
                            vEmail = PasarAjaValidation.email('');
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    AuthInputText(
                      title: 'Masukan Password',
                      textField: AuthTextField(
                        controller: pwCont,
                        hintText: 'xxxxxxxx',
                        fontSize: 18,
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
                        content: Text('Goto Main'),
                      ),
                    );
                  },
                  state: state,
                  title: 'Masuk'),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  setState(
                    () => state = AuthFilledButton.stateLoadingButton,
                  );
                  await Future.delayed(
                    const Duration(seconds: PasarAjaConstant.initLoading),
                  );
                  setState(
                    () => state = AuthFilledButton.stateEnabledButton,
                  );
                  Navigator.pushNamed(context, RouteName.verifyPin);
                },
                child: Text(
                  'Lupa Kata Sandi',
                  style: PasarAjaTypography.sfpdMedium,
                ),
              ),
              const SizedBox(height: 15),
              Image.asset(
                PasarAjaImage.icGoogle,
                width: 38,
                height: 38,
              )
            ],
          ),
        ),
      ),
    );
  }
}
