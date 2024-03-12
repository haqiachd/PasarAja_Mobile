import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: const Text('Ya'),
        ),
      ],
    );
  }
}
