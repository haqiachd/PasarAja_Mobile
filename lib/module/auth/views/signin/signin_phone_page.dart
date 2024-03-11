import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/providers/signin/signin_phone_provider.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignInPhonePage extends StatefulWidget {
  const SignInPhonePage({super.key});

  @override
  State<SignInPhonePage> createState() => _SignInPhonePageState();
}

class _SignInPhonePageState extends State<SignInPhonePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SignInPhoneProvider>(context, listen: false).resetData();
    });
    super.initState();
  }

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
                      child: _buildTextFieldPhone(context),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildHelperMessage(context),
              ),
              const SizedBox(height: 40),
              _buildButtonBerikutnya(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper Message
Widget _buildHelperMessage(BuildContext context) {
  return Consumer<SignInPhoneProvider>(
    builder: (context, provider, child) {
      return AuthHelperText(
        title: provider.showHelperText(provider.message.toString()),
      );
    },
  );
}

/// Input Nomor HP
Widget _buildTextFieldPhone(BuildContext context) {
  return Consumer<SignInPhoneProvider>(
    builder: (context, provider, child) {
      DMethod.log('build textfield phone');
      // Mendapatkan instance SignInPhoneProvider
      final phoneCont = provider.phoneCont;

      // Membangun tampilan TextField
      return AuthTextField(
        controller: phoneCont,
        hintText: '82-xxxx-xxxx',
        keyboardType: TextInputType.number,
        formatters: AuthTextField.numberFormatter(),
        errorText: provider.message.toString(),
        showHelper: false,
        onChanged: (value) {
          // update controller
          provider.onValidatePhone(value);
        },
        suffixAction: () {
          // reset text phone menjadi null
          phoneCont.text = '';
          provider.vPhone = PasarAjaValidation.phone('');
          provider.message = provider.vPhone.message.toString();
          provider.buttonState = AuthFilledButton.stateDisabledButton;
        },
      );
    },
  );
}

/// Button Berikutnya
Widget _buildButtonBerikutnya(BuildContext context) {
  return Consumer<SignInPhoneProvider>(
    builder: (context, provider, child) {
      DMethod.log('build button berikutnya');
      return AuthFilledButton(
        onPressed: () async {
          // action saat login
          provider.onPressedButtonBerikutnya(
            phone: "62${provider.phoneCont.text}",
          );
          DMethod.log('phone num : 62${provider.phoneCont.text}');
        },
        state: provider.buttonState, // update state
        title: 'Berikutnya',
      );
    },
  );
}
