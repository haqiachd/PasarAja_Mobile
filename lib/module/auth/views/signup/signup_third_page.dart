import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/providers/signup/signup_third_provider.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SignUpThirdPage extends StatefulWidget {
  final UserModel user;
  const SignUpThirdPage({
    super.key,
    required this.user,
  });

  @override
  State<SignUpThirdPage> createState() => _SignUpThirdPageState();
}

class _SignUpThirdPageState extends State<SignUpThirdPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SignUpThirdProvider>(context, listen: false).resetData();
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
            'Apakah Anda yakin ingin kembali, Jika Anda kembali maka pembuatan akun akan dibatalkan',
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
                top: 176 - MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                const AuthInit(
                  image: PasarAjaImage.ilNewPin,
                  title: 'Buat PIN Baru',
                  description:
                      'Buatlah PIN yang kuat dan jangan bagikan PIN Anda kepada orang lain.',
                ),
                const SizedBox(
                  height: 19,
                ),
                Column(
                  children: [
                    _buildInputPin(),
                  ],
                ),
                const SizedBox(height: 40),
                _buildButtonBerikutnya(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Input Pin
  _buildInputPin() {
    return Consumer<SignUpThirdProvider>(
      builder: (context, provider, child) {
        //
        final pinCont = provider.pinCont;

        return AuthInputPin(
          title: 'Masukan PIN',
          authPin: AuthPin(
            controller: pinCont,
            length: 6,
            onChanged: (value) {
              provider.onValidatePin(value);
              DMethod.log("PIIIN : ${pinCont.text}");
            },
          ),
        );
      },
    );
  }

  /// Button Berikutnya
  _buildButtonBerikutnya() {
    return Consumer<SignUpThirdProvider>(
      builder: (context, provider, child) {
        return AuthFilledButton(
          onPressed: () {
            DMethod.log('Password From Third  Page: ${provider.pinCont.text}');

            // aksi saat button di klik
            provider.onPressedButtonBerikutnya(
              user: widget.user,
              createdPin: provider.pinCont.text,
            );
          },
          state: provider.buttonState,
          title: 'Berikutnya',
        );
      },
    );
  }
}
