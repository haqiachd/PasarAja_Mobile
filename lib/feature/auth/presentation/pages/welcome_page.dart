import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/routes/route_names.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/core/utils/local_data.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/copyright_text.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/filled_button.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/item_welcome.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/outlined_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int state = AuthFilledButton.stateEnabledButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 223 -
                    MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).padding.bottom,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...PasarAjaLocalData.wecomeList.map(
                      (data) => ItemWelcome(
                        image: data.image,
                        title: data.title,
                        description: data.description,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 43),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: Material(
                        color: PasarAjaColor.green1,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: Material(
                        color: PasarAjaColor.gray2,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3, right: 3),
                    child: SizedBox(
                      width: 5,
                      height: 5,
                      child: Material(
                        color: PasarAjaColor.gray2,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AuthFilledButton(
                onPressed: _masukOnPressed(context),
                state: state,
                title: 'Ayo Masuk',
              ),
              const SizedBox(height: 16),
              AuthOutlinedButton(
                onPressed: _registerOnPressed(context),
                title: 'Daftarkan Diri Anda',
              ),
              const SizedBox(height: 40),
              const CopyrightText()
            ],
          ),
        ),
      ),
    );
  }
}

_masukOnPressed(BuildContext context) {
  return () {
    Navigator.pushNamed(context, RouteName.loginPhone);
  };
}

_registerOnPressed(BuildContext context) {
  return () {
    Navigator.pushNamed(context, RouteName.signupFirst);
  };
}
