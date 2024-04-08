import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ImageErrorNetwork extends StatelessWidget {
  const ImageErrorNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PasarAjaColor.gray4,
      child: Center(
        child: Text(
          'Gambar',
          style: PasarAjaTypography.sfpdSemibold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
