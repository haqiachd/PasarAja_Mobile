import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class SwitcherSetting extends StatelessWidget {
  const SwitcherSetting({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: PasarAjaTypography.sfpdSemibold.copyWith(
            fontSize: 18,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}