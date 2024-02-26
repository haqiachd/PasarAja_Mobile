import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthHelperText extends StatelessWidget {
  final String? title;
  const AuthHelperText({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title != 'valid' ? title ?? '' : '',
      style: PasarAjaTypography.sfpdAuthHelper,
    );
  }
}
