import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_title.dart';
import 'package:pasaraja_mobile/config/widgets/app_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';

class AppInputTextArea extends StatelessWidget {
  final String? title;
  final AppTextArea textArea;
  const AppInputTextArea({
    super.key,
    required this.title,
    required this.textArea,
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
        textArea,
      ],
    );
  }
}
