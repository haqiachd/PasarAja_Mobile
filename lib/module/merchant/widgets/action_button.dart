import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String title;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
      ),
      child: Text(
        title,
        style: PasarAjaTypography.sfpdBold.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}