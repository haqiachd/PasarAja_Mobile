import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthCountries extends StatelessWidget {
  const AuthCountries({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 30,
      child: Material(
        color: PasarAjaColor.gray6,
        shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: PasarAjaColor.gray3,
              width: 0.8,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: Center(
            child: Row(
              children: [
                Image.asset(
                  PasarAjaImage.icIndonesianFlag,
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 2),
                Text(
                  '+62',
                  style: PasarAjaTypography.sfpdMedium.copyWith(fontSize: 11),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
