import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthDescription extends StatelessWidget {
  final String? description;
  const AuthDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description ?? '[description]',
      textAlign: TextAlign.start,
      style: PasarAjaTypography.sfpdAuthDescription,
    );
  }
}
