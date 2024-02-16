import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthImage extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;
  const AuthImage({
    super.key,
    required this.image,
    this.width,
    this.height,
  });

  final double widthDef = 348, heightDef = 212, radius = 40;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
      child: Image.asset(
        image ?? '',
        width: width ?? widthDef,
        height: height ?? heightDef,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: width ?? widthDef,
            height: height ?? heightDef,
            child: Material(
              color: PasarAjaColor.gray3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
              ),
              child: Center(
                child: Text(
                  'Gambar tidak ditemukan',
                  style: PasarAjaTypography.sfpdBold.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
