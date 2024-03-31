import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AppInputTitle extends StatelessWidget {
  final String? title;
  final bool? isOptional;
  const AppInputTitle({
    super.key,
    this.title,
    this.isOptional,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: PasarAjaTypography.sfpdAuthInputTitle,
        children: [
          TextSpan(
            text: title,
            style: PasarAjaTypography.sfpdAuthInputTitle.copyWith(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: "  *",
            style: PasarAjaTypography.sfpdAuthInputTitle.copyWith(
              color: PasarAjaColor.red1,
            ),
          )
        ],
      ),
    );
  }
}
