import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;
  final double? width;
  final double? height;
  const AuthFilledButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 330,
      height: height ?? 43,
      child: FilledButton(
        onPressed: onPressed,
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(PasarAjaColor.green2),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
        ),
        child: Text(
          title ?? '[button]',
          style: PasarAjaTypography.sfpdAuthFilledButton,
        ),
      ),
    );
  }
}
