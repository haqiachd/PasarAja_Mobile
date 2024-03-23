import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Coming Soon',
        style: PasarAjaTypography.sfpdBold.copyWith(
          color: PasarAjaColor.green1,
          fontSize: 30,
        ),
      ),
    );
  }
}