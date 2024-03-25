import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/input_title.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/textfield.dart';

class MerchantInputText extends StatelessWidget {
  final String? title;
  final MerchantTextField textField;
  const MerchantInputText({
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
          child: MerchantInputTitle(title: title),
        ),
        const SizedBox(height: 5),
        textField,
      ],
    );
  }
}
