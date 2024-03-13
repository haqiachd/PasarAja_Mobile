import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/services/google_signin_services.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/providers/signup/signup_second_provider.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignUpSecondPage extends StatefulWidget {
  final String phone;
  const SignUpSecondPage({
    super.key,
    required this.phone,
  });

  @override
  State<SignUpSecondPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpSecondPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SignUpSecondProvider>(context, listen: false).resetData();
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
            top: 64 - MediaQuery.of(context).padding.top,
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
                    _buildInputEmail(),
                    const SizedBox(height: 12),
                    _buildInputNama(),
                    const SizedBox(height: 12),
                    _buildInputPassword(),
                    const SizedBox(height: 12),
                    _buildInputKonfirmasi(),
                    const SizedBox(height: 40),
                    _buildButtonBerikutnya(),
                    const SizedBox(height: 40),
                    _buildButtonLoginGoogle(context),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildInputEmail() {
    return Consumer<SignUpSecondProvider>(
      builder: (context, provider, child) {
        //
        final emailCont = provider.emailCont;

        return AuthInputText(
          title: 'Masukan Email',
          textField: AuthTextField(
            controller: emailCont,
            hintText: 'Email Anda',
            fontSize: 20,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            errorText: provider.vEmail.message,
            onChanged: (value) {
              provider.onValidateEmail(value);
            },
            suffixAction: () {
              emailCont.text = '';
              provider.vEmail = PasarAjaValidation.email('');
              provider.buttonState = AuthFilledButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildInputNama() {
    return Consumer<SignUpSecondProvider>(
      builder: (context, provider, child) {
        //
        final nameCont = provider.nameCont;

        return AuthInputText(
          title: 'Masukan Nama',
          textField: AuthTextField(
            controller: nameCont,
            hintText: 'Nama Anda',
            fontSize: 20,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            errorText: provider.vName.message,
            onChanged: (value) {
              provider.onValidateName(value);
            },
            suffixAction: () {
              nameCont.text = '';
              provider.vName = PasarAjaValidation.name('');
              provider.buttonState = AuthFilledButton.stateDisabledButton;
            },
          ),
        );
      },
    );
  }

  _buildInputPassword() {
    return Consumer<SignUpSecondProvider>(
      builder: (context, provider, child) {
        //
        final pwCont = provider.pwCont;

        return AuthInputText(
          title: 'Masukan Kata Sandi',
          textField: AuthTextField(
            controller: pwCont,
            hintText: 'xxxxxxxx',
            fontSize: 20,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            obscureText: provider.obscurePass,
            errorText: provider.vPass.message,
            suffixIcon: AuthTextField.hiddenPassword(provider.obscurePass),
            onChanged: (value) {
              provider.onValidatePassword(
                value,
                provider.konfCont.text,
              );
            },
            suffixAction: () {
              provider.obscurePass = !provider.obscurePass;
            },
          ),
        );
      },
    );
  }

  _buildInputKonfirmasi() {
    return Consumer<SignUpSecondProvider>(
      builder: (context, provider, child) {
        //
        final konfCont = provider.konfCont;

        return AuthInputText(
          title: 'Konfirmasi Kata Sandi',
          textField: AuthTextField(
            controller: konfCont,
            hintText: 'xxxxxxxx',
            errorText: provider.vKonf.message,
            fontSize: 20,
            obscureText: provider.obscureKonf,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            suffixIcon: AuthTextField.hiddenPassword(provider.obscureKonf),
            onChanged: (value) {
              // check apakah password cocok atau tidak
              provider.onValidateKonf(provider.pwCont.text, value);
            },
            suffixAction: () {
              provider.obscureKonf = !provider.obscureKonf;
            },
          ),
        );
      },
    );
  }

  _buildButtonBerikutnya() {
    return Consumer<SignUpSecondProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () {
            provider.onPressedButtonBerikutnya(
              phone: widget.phone,
              email: provider.emailCont.text,
              fullName: provider.nameCont.text,
              password: provider.pwCont.text,
            );
          },
          state: provider.buttonState,
          title: 'Berikutnya',
        );
      },
    );
  }

  _buildButtonLoginGoogle(BuildContext context) {
    return Consumer2<SignUpSecondProvider, GoogleSignService>(
      builder: (context, signUpProvider, googleProvider, child) {
        return InkWell(
          onTap: () async {
            // show google auth
            await googleProvider.googleLogin();

            // get user data
            signUpProvider.onTapButtonGoogle(
              user: googleProvider.user,
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
