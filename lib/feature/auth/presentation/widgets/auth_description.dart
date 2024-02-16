import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthDescription extends StatelessWidget {
  final String? description;
  final TextAlign? textAlign;
  const AuthDescription({
    super.key,
    required this.description,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description ?? '[description]',
      textAlign: textAlign ?? TextAlign.start,
      style: PasarAjaTypography.sfpdAuthDescription,
    );
  }
}
