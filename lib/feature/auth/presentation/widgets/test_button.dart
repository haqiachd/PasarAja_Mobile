import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  static const int stateDisabledButton = 1;
  static const int stateLoadingButton = 2;
  static const int stateEnabledButton = 3;
  final String title;
  final int state;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.title,
    required this.state,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _background(state),
          foregroundColor: Colors.white,
          shadowColor: _background(state),
          elevation: 4,
          shape: const StadiumBorder(),
        ),
        child: state == stateLoadingButton
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ],
              )
            : Text(title),
      ),
    );
  }
}

_background(int state) {
  switch (state) {
    case CustomElevatedButton.stateEnabledButton:
      return PasarAjaColor.green2;
    case CustomElevatedButton.stateLoadingButton:
      return PasarAjaColor.green2;
    case CustomElevatedButton.stateDisabledButton:
      return PasarAjaColor.gray4.withOpacity(0.5);
    default:
      return PasarAjaColor.green2;
  }
}
