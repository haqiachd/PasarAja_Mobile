import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/dialog_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? actionYes;
  final String? actionCancel;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    this.actionYes,
    this.actionCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: PasarAjaTypography.sfpdSemibold.copyWith(
          fontSize: 20,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          message,
          style: PasarAjaTypography.sfpdRegular.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      actions: [
        DialogButton(
          onPressed: () {
            Get.back(result: false);
          },
          actionName: actionCancel ?? 'Tidak',
          isDestructiveAction: true,
        ),
        DialogButton(
          onPressed: () {
            Get.back(result: true);
          },
          actionName: actionYes ?? 'Iya',
        ),
      ],
    );
  }
}
