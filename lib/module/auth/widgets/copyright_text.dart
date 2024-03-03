import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';

class CopyrightText extends StatelessWidget {
  const CopyrightText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      PasarAjaConstant.rights,
      textAlign: TextAlign.center,
      style: PasarAjaTypography.sfpdRightText,
    );
  }
}
