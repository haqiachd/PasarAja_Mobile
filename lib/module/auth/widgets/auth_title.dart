import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthTitle extends StatelessWidget {
  final String? title;
  final TextAlign? textAlign;
  const AuthTitle({
    super.key,
    required this.title,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '[judul]',
      textAlign: textAlign ?? TextAlign.start,
      style: PasarAjaTypography.sfpdAuthTitle,
    );
  }
}
