import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderAcc extends StatelessWidget {
  const OrderAcc({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(PasarAjaColor.green1),
        foregroundColor: const MaterialStatePropertyAll(PasarAjaColor.white),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: PasarAjaTypography.sfpdSemibold,
        ),
      ),
    );
  }
}
