import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/services/google_signin_services.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/providers/providers.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignInGooglePage extends StatefulWidget {
  const SignInGooglePage({super.key});

  @override
  State<SignInGooglePage> createState() => _SignInGooglePageState();
}

class _SignInGooglePageState extends State<SignInGooglePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SignInGoogleProvider>(context, listen: false).resetData();
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
            top: 70 - MediaQuery.of(context).padding.top,
            left: 19,
            right: 19,
          ),
          child: Column(
            children: [
              const AuthInit(
                image: PasarAjaImage.ilLoginEmail,
                title: 'Masuk Akun',
                haveImage: true,
                description:
                    'Silakan masukkan email dan kata sandi Anda untuk masuk ke dalam aplikasi.',
              ),
              const SizedBox(height: 19),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    _buildInputEmail(),
                    const SizedBox(height: 12),
                    _buildInputPassword()
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildButtonMasuk(),
              const SizedBox(height: 40),
              _buildButtonLupaSandi(context),
              const SizedBox(height: 20),
              _buildButtonLoginGoogle(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  _buildInputEmail() {
    return Consumer<SignInGoogleProvider>(
      builder: (context, provider, child) {
        // DMethod.log('build input email');
        // get email controller
        final emailCont = provider.emailCont;

        return AuthInputText(
          title: 'Masukan Email',
          textField: AuthTextField(
            controller: emailCont,
            hintText: 'pasaraja@email.com',
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            fontSize: 18,
            errorText: provider.vEmail.message,
            onChanged: (value) {
              provider.onValidateEmail(value);
            },
            suffixAction: () {
              emailCont.text = '';
              provider.vEmail = PasarAjaValidation.email('');
              provider.message = provider.vEmail.message.toString();
              provider.buttonState = AuthFilledButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildInputPassword() {
    return Consumer<SignInGoogleProvider>(
      builder: (context, provider, child) {
        // get password controller
        final pwCont = provider.passCont;
        // DMethod.log('build input password');

        return AuthInputText(
          title: 'Masukan Password',
          textField: AuthTextField(
            controller: pwCont,
            hintText: 'xxxxxxxx',
            errorText: provider.vPass.message,
            obscureText: provider.obscure,
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [
              AutofillHints.password,
              AutofillHints.newPassword,
            ],
            fontSize: 18,
            suffixIcon: AuthTextField.hiddenPassword(provider.obscure),
            onChanged: (value) {
              provider.onValidatePassword(value);
            },
            suffixAction: () {
              provider.obscure = !provider.obscure;
            },
          ),
        );
      },
    );
  }

  _buildButtonMasuk() {
    return Consumer<SignInGoogleProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          state: provider.buttonState,
          title: 'Masuk',
          onPressed: () {
            DMethod.log('button masuk onpressed');
            provider.onPressedButtonMasuk(
              email: provider.emailCont.text,
              password: provider.passCont.text,
            );
          },
        );
      },
    );
  }

  _buildButtonLupaSandi(BuildContext context) {
    return Consumer<SignInGoogleProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () {
            provider.onValidateEmail(provider.emailCont.text);
            provider.onTapButtonLupaSandi(
              email: provider.emailCont.text,
            );
          },
          child: Text(
            'Lupa Kata Sandi',
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  _buildButtonLoginGoogle(BuildContext context) {
    return Consumer2<SignInGoogleProvider, GoogleSignService>(
      builder: (context, signInProvider, googleProvider, child) {
        return InkWell(
          onTap: () async {
            // show google auth
            await googleProvider.googleLogin();

            // login dengan google
            signInProvider.onTapButtonLoginGoogle(
              email: googleProvider.user.email,
            );

            googleProvider.logout();
          },
          child: Image.asset(
            PasarAjaImage.icGoogle,
            width: 38,
            height: 38,
          ),
        );
      },
    );
  }
}
