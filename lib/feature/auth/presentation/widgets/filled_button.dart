import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthFilledButton extends StatelessWidget {
  static const int stateDisabledButton = 1;
  static const int stateLoadingButton = 2;
  static const int stateEnabledButton = 3;
  //
  final VoidCallback onPressed;
  final String title;
  final double width;
  final double height;
  final int state;
  //
  const AuthFilledButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.state,
    this.width = 330,
    this.height = 43,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: _background(state),
        shape: const StadiumBorder(),
        shadowColor: _background(state),
        elevation: 4,
        child: InkWell(
          onTap: state == stateEnabledButton ? onPressed : null,
          splashColor: PasarAjaColor.gray2,
          customBorder: const StadiumBorder(),
          child: Center(
            child: Stack(
              children: [
                Visibility(
                  visible: state != stateLoadingButton,
                  child: Text(
                    title,
                    style: PasarAjaTypography.sfpdAuthFilledButton,
                  ),
                ),
                Visibility(
                  visible: state == stateLoadingButton,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: LottieBuilder.asset(
                        'assets/raws/loading.json',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_background(int state) {
  switch (state) {
    case AuthFilledButton.stateEnabledButton:
      return PasarAjaColor.green2;
    case AuthFilledButton.stateLoadingButton:
      return PasarAjaColor.green2;
    case AuthFilledButton.stateDisabledButton:
      return PasarAjaColor.gray4.withOpacity(0.5);
  }
}
