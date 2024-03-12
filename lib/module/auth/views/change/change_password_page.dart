import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/auth/providers/change/change_password_provider.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;
  const ChangePasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChangePasswordProvider>(
        context,
        listen: false,
      ).resetData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final metu = await PasarAjaUtils.showConfirmBack(
            "Apakah Anda yakin ingin keluar, Jika ya maka password tidak akan diubah",
          );

          if (metu) {
            Get.offAll(
              const WelcomePage(),
              transition: Transition.rightToLeft,
              duration: PasarAjaConstant.transitionDuration,
            );
          }
        }
      },
      child: Scaffold(
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
                      _buildInputPassword(),
                      const SizedBox(height: 12),
                      _buildInputKonfirmasi()
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildButtonGanti(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildInputPassword() {
    return Consumer<ChangePasswordProvider>(
      builder: (context, provider, child) {
        //
        final pwCont = provider.pwCont;

        return AuthInputText(
          title: 'Masukan Kata Sandi',
          textField: AuthTextField(
            controller: pwCont,
            hintText: 'xxxxxxxx',
            obscureText: provider.obscurePass,
            fontSize: 20,
            errorText: provider.vPass.message,
            keyboardType: TextInputType.visiblePassword,
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
    return Consumer<ChangePasswordProvider>(
      builder: (context, provider, child) {
        //
        final konfCont = provider.konfCont;

        return AuthInputText(
          title: 'Konfirmasi Kata Sandi',
          textField: AuthTextField(
            controller: konfCont,
            hintText: 'xxxxxxxx',
            obscureText: provider.obscureKonf,
            fontSize: 20,
            errorText: provider.vKonf.message,
            keyboardType: TextInputType.visiblePassword,
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

  _buildButtonGanti() {
    return Consumer<ChangePasswordProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () async {
            provider.onPressedGantiPassword(
              email: widget.email,
              password: provider.pwCont.text,
            );
          },
          state: provider.buttonState,
          title: 'Ganti Kata Sandi',
        );
      },
    );
  }
}
