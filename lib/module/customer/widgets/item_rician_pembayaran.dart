import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';

class ItemRicianPembayaran extends StatelessWidget {
  const ItemRicianPembayaran({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: PasarAjaTypography.sfpdMedium.copyWith(
            fontSize: 16,
          ),
        ),
        Text(rightText,
          style: PasarAjaTypography.sfpdRegular.copyWith(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
