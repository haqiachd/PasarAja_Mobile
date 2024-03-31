import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_title.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';

class AppInputText extends StatelessWidget {
  final String? title;
  final AppTextField textField;
  const AppInputText({
    super.key,
    required this.title,
    required this.textField,
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
        textField,
      ],
    );
  }
}
