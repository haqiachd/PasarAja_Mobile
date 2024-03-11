import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/providers/signup/signup_first_provider.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignUpPhonePage extends StatefulWidget {
  const SignUpPhonePage({super.key});

  @override
  State<SignUpPhonePage> createState() => _SignUpPhonePageState();
}

class _SignUpPhonePageState extends State<SignUpPhonePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SignUpFirstProvider>(context, listen: false).resetData();
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
              top: 136 - MediaQuery.of(context).padding.top),
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
                      child: _buildInputPhone(),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildHelperText(),
              ),
              const SizedBox(height: 40),
              _buildButtonBerikutnya(),
              const SizedBox(height: 20),
              _buildButtonSkip(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Input Nomor HP
  _buildInputPhone() {
    return Consumer<SignUpFirstProvider>(
      builder: (context, provider, child) {
        // Mendapatkan instance SignUpFirstProvider
        final phoneCont = provider.phoneCont;

        return AuthTextField(
          controller: phoneCont,
          hintText: '82-xxxx-xxxx',
          errorText: provider.message.toString(),
          keyboardType: TextInputType.number,
          showHelper: false,
          formatters: AuthTextField.numberFormatter(),
          onChanged: (value) {
            provider.onValidatePhone(value);
          },
          suffixAction: () {
            phoneCont.text = '';
            provider.vPhone = PasarAjaValidation.phone('');
            provider.message = provider.vPhone.message.toString();
            provider.buttonState = AuthFilledButton.stateDisabledButton;
          },
        );
      },
    );
  }

  // Helper Text
  _buildHelperText() {
    return Consumer<SignUpFirstProvider>(
      builder: (context, provider, child) {
        return AuthHelperText(
          title: provider.showHelperText(
            provider.message.toString(),
          ),
        );
      },
    );
  }

  // Button Berikutnya
  _buildButtonBerikutnya() {
    return Consumer<SignUpFirstProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () async {
            provider.onPressedButtonBerikutnya(
              phone: "62${provider.phoneCont.text}",
            );
          },
          state: provider.buttonState,
          title: 'Berikutnya',
        );
      },
    );
  }

  // Button Berikutnya
  _buildButtonSkip() {
    return AuthOutlinedButton(
      onPressed: () async {
        Provider.of<SignUpFirstProvider>(
          context,
          listen: false,
        ).onPressedButtonSkip();
      },
      title: 'Lewati Nomor HP',
    );
  }
}
