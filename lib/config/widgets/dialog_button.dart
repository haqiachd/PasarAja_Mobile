import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';

class DialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String actionName;
  final bool isDestructiveAction;

  const DialogButton({
    Key? key,
    required this.onPressed,
    required this.actionName,
    this.isDestructiveAction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoDialogAction(
      isDestructiveAction: isDestructiveAction,
      onPressed: onPressed,
      child: Text(
        actionName,
        style: PasarAjaTypography.sfpdSemibold.copyWith(
          color: isDestructiveAction ? Colors.red : Colors.blueAccent[700],
        ),
      ),
    );
  }
}
