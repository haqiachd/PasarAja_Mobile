import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constant/constants.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_init.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/countries.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/textfield.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/input_title.dart';

class SignInPhonePage extends StatefulWidget {
  const SignInPhonePage({super.key});

  @override
  State<SignInPhonePage> createState() => _SignInPhonePageState();
}

class _SignInPhonePageState extends State<SignInPhonePage> {
  TextEditingController noHpController = TextEditingController();
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PasarAjaColor.white,
        toolbarHeight: PasarAjaConstant.authTolbarHeight,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 176 -
                    (MediaQuery.of(context).padding.top +
                        PasarAjaConstant.authTolbarHeight),
              ),
              const AuthInit(
                image: PasarAjaImage.ilLoginPhone,
                title: 'Masuk Akun',
                description:
                    'Silakan masukkan nomor HP Anda untuk masuk ke dalam aplikasi.',
              ),
              const SizedBox(height: 19),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthInputTitle(title: 'Masukan Nomor Hp'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: AuthCountries(),
                      ),
                      const SizedBox(width: 13),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 5,
                        child: AuthTextField(
                          controller: noHpController,
                          onChanged: (text) {
                            if (text.length <= 8) {
                              error = 'No HP tidak valid bang';
                            } else {
                              error = '';
                            }
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          obscureText: false,
                          hintText: '85-xxxx-xxxx',
                          maxLength: 15,
                          suffixAction: () {
                            noHpController.text = '';
                          },
                          errorText: error,
                          suffixIcon: SvgPicture.asset(
                            PasarAjaIcon.icClearText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: AuthFilledButton(
                  onPressed: _nextOnPressed(context),
                  title: 'Berikutnya',
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

_nextOnPressed(BuildContext context) {
  Navigator.pushNamed(context, RouteName.verifyPin);
}
