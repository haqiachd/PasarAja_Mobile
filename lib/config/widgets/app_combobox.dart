import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AppComboBox extends StatelessWidget {
  const AppComboBox({
    super.key,
    required this.selected,
    required this.items,
    required this.onChanged,
  });

  final String selected;
  final void Function(String?)? onChanged;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
        color: Colors.grey[200],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: onChanged,
          items: items.map(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: PasarAjaTypography.sfpdSemibold.copyWith(
                    fontSize: 16,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
