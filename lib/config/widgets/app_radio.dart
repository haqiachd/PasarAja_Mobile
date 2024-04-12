import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AppRadio extends StatelessWidget {
  const AppRadio({
    Key? key,
    required this.title,
    required this.onChange,
    this.isSelected = false,
  }) : super(key: key);

  final String title;
  final Function(bool value) onChange;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: true,
          groupValue: isSelected,
          onChanged: (value) {
            onChange(value as bool);
          },
        ),
        Text(
          title,
          style: PasarAjaTypography.sfpdBold,
        ),
      ],
    );
  }
}
