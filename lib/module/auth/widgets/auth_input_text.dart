import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/module/auth/widgets/input_title.dart';
import 'package:pasaraja_mobile/module/auth/widgets/textfield.dart';

class AuthInputText extends StatelessWidget {
  final String? title;
  final AuthTextField textField;
  const AuthInputText({
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
          child: AuthInputTitle(title: title),
        ),
        const SizedBox(height: 5),
        textField,
      ],
    );
  }
}
