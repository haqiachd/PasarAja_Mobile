import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/widgets/app_combobox.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_title.dart';

class AppInputComboBox extends StatelessWidget {
  final String? title;
  final AppComboBox comboBox;
  const AppInputComboBox({
    super.key,
    required this.title,
    required this.comboBox,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: AppInputTitle(title: title),
        ),
        const SizedBox(height: 5),
        comboBox,
      ],
    );
  }
}
