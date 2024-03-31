import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class SwitcherSetting extends StatelessWidget {
  const SwitcherSetting({
    super.key,
    required this.title,
    this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: PasarAjaTypography.sfpdSemibold.copyWith(
                fontSize: 18,
              ),
            ),
            Visibility(
              visible: description != null,
              child: Text(
                description ?? 'null',
                style: PasarAjaTypography.sfpdRegular.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
