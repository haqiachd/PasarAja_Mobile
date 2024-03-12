import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/confirm_dialog.dart';
import 'package:pasaraja_mobile/config/widgets/information_dialog.dart';

class PasarAjaMessage {
  //
  static Future<bool> _createPop(
    Widget widget, {
    bool barrierDismissible = false,
  }) async {
    final result = await Get.dialog<bool>(
      PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            Get.back(result: false);
          }
        },
        child: widget,
      ),
      barrierDismissible: barrierDismissible,
    );

    return result != null && result;
  }

  //
  static Future<bool> showInformation(
    String message, {
    bool barrierDismissible = false,
  }) async {
    return await _createPop(
      InformationDialog(
        title: "Informasi",
        message: message,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  //
  static Future<bool> showConfirmation(
    String message, {
    bool barrierDismissible = false,
  }) async {
    return await _createPop(
      ConfirmDialog(
        title: "Konfirmasi",
        message: message,
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
