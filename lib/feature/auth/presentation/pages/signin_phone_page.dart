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
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/textfield.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/input_title.dart';

class SignInPhonePage extends StatefulWidget {
  const SignInPhonePage({super.key});

  @override
  State<SignInPhonePage> createState() => _SignInPhonePageState();
}

class _SignInPhonePageState extends State<SignInPhonePage> {
  final TextEditingController phoneCont = TextEditingController();
  ValidationModel vPhone = PasarAjaValidation.phone(null);
  int state = AuthFilledButton.stateEnabledButton;
  String error = '';
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
                title: 'Masuk Akun',
                description:
                    'Silakan masukkan nomor HP Anda untuk masuk ke dalam aplikasi.',
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
                        controller: phoneCont,
                        hintText: '82-xxxx-xxxx',
                        keyboardType: TextInputType.number,
                        formatters: AuthTextField.numberFormatter(),
                        errorText: vPhone.message,
                        showHelper: false,
                        onChanged: (value) {
                          // valdasi data
                          vPhone = PasarAjaValidation.phone(value);
                          // enable and disable button
                          if (vPhone.status == true) {
                            state = AuthFilledButton.stateEnabledButton;
                          } else {
                            state = AuthFilledButton.stateDisabledButton;
                          }
                          setState(() {});
                        },
                        suffixAction: () {
                          phoneCont.text = '';
                          vPhone = PasarAjaValidation.phone('');
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AuthHelperText(
                  title: vPhone.message != 'Data valid' ? vPhone.message : null,
                ),
              ),
              const SizedBox(height: 40),
              AuthFilledButton(
                onPressed: () async {
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
