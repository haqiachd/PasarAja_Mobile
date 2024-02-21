import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthButton extends StatelessWidget {
  static const int stateDisabledButton = 1;
  static const int stateLoadingButton = 2;
  static const int stateEnabledButton = 3;
  //
  final void Function()? onTap;
  int state;
  AuthButton({
    super.key,
    this.onTap,
    this.state = stateDisabledButton,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 43,
      child: Material(
        color: _background(state),
        shape: const StadiumBorder(),
        shadowColor: _background(state),
        elevation: 4,
        child: InkWell(
          onTap: state == stateEnabledButton
              ? () {
                  state = stateLoadingButton;
                  setState() {}
                  print(state);
                }
              : null,
          splashColor: PasarAjaColor.gray2,
          customBorder: const StadiumBorder(),
          child: Center(
            child: Stack(
              children: [
                Visibility(
                  visible: state != stateLoadingButton,
                  child: Text(
                    'Masuk',
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

_color(bool enabled) {
  return enabled ? PasarAjaColor.green2 : PasarAjaColor.gray3;
}

_background(int state) {
  switch (state) {
    case AuthButton.stateEnabledButton:
      return PasarAjaColor.green2;
    case AuthButton.stateLoadingButton:
      return PasarAjaColor.green2;
    case AuthButton.stateDisabledButton:
      return PasarAjaColor.gray4.withOpacity(0.5);
  }
}
