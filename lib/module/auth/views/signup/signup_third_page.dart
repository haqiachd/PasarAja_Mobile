import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:pasaraja_mobile/module/auth/views/signup/signup_fourth_page.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class SingUpCreatePin extends StatefulWidget {
  final UserModel user;
  const SingUpCreatePin({
    super.key,
    required this.user,
  });

  @override
  State<SingUpCreatePin> createState() => _SingUpCreatePinState(user);
}

class _SingUpCreatePinState extends State<SingUpCreatePin> {
  final TextEditingController pinCont = TextEditingController();
  ValidationModel vPin = PasarAjaValidation.pin(null);
  //
  final UserModel user;
  int state = AuthFilledButton.stateDisabledButton;
  String? errMessage;
  //
  _SingUpCreatePinState(this.user);

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
                  AuthInputPin(
                    title: 'Masukan PIN',
                    authPin: AuthPin(
                      controller: pinCont,
                      length: 6,
                      onChanged: (value) {
                        vPin = PasarAjaValidation.pin(value);
                        state = _buttonState(vPin.status);
                        pinCont.text = value;
                        print(pinCont.text);
                        setState(() {});
                      },
                    ),
                  ),
                ],
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
                  Get.to(
                    SignUpConfirmPage(user: user, createdPin: pinCont.text),
                    transition: Transition.downToUp,
                  );
                  // Navigator.pushNamed(context, RouteName.signupFourth);
                  // Navigator.pop(context);
                },
                state: state,
                title: 'Berikutnya',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

int _buttonState(bool? v1) {
  if (v1 == null) {
    return AuthFilledButton.stateDisabledButton;
  }

  return v1
      ? AuthFilledButton.stateEnabledButton
      : AuthFilledButton.stateDisabledButton;
}
