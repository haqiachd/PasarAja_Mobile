import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/confirm_dialog.dart';
import 'package:pasaraja_mobile/config/widgets/information_dialog.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';

class PasarAjaMessage {
  /// dialog maker
  static Future<bool> _createPop(
    Widget widget, {
    bool barrierDismissible = false,
    bool triggerVibration = false,
  }) async {
    if (triggerVibration) PasarAjaUtils.triggerVibration();
    // show dialog
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

  ///
  static Future<bool> showInformation(
    String message, {
    bool barrierDismissible = false,
    bool triggerVibration = false,
    String? actionYes,
  }) async {
    return await _createPop(
      InformationDialog(
        title: "Informasi",
        message: message,
        actionYes: actionYes,
      ),
      barrierDismissible: barrierDismissible,
      triggerVibration: triggerVibration,
    );
  }

  ///
  static Future<bool> showConfirmation(
    String message, {
    bool barrierDismissible = false,
    bool triggerVibration = false,
    String? actionYes,
    String? actionCancel,
  }) async {
    return await _createPop(
      ConfirmDialog(
        title: "Konfirmasi",
        message: message,
        actionYes: actionYes,
        actionCancel: actionCancel,
      ),
      barrierDismissible: barrierDismissible,
      triggerVibration: triggerVibration,
    );
  }

  ///
  static Future<bool> showConfirmBack(
    String message, {
    bool triggerVibration = false,
  }) async {
    if (triggerVibration) PasarAjaUtils.triggerVibration();
    final result = await Get.dialog<bool>(
      ConfirmDialog(
        title: "Konfirmasi",
        message: message,
        actionYes: "Batal",
        actionCancel: "Keluar",
      ),
    );
    return result != null && !result;
  }

  ///
  static showLoading() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: PasarAjaColor.green2,
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeOut,
    );
  }

  static _showSnackbar(
    String title,
    String message, {
    Color? background,
    Color? foreground,
  }) {
    Get.snackbar(
      title,
      titleText: Text(
        title,
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 16,
          color: foreground,
        ),
      ),
      message.toString(),
      messageText: Text(
        message,
        style: PasarAjaTypography.sfpdRegular.copyWith(
          fontSize: 14,
          color: foreground,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: background,
      colorText: foreground,
      borderRadius: 10,
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      duration: const Duration(milliseconds: 2500),
      isDismissible: true,
      dismissDirection: DismissDirection.vertical,
      overlayColor: Colors.white.withOpacity(0.5),
      barBlur: 20,
      overlayBlur: 0.2,
      onTap: (snack) {
        Get.back();
      },
    );
  }

  ///
  static showSnackbarInfo(String message) {
    _showSnackbar(
      "Informasi",
      message,
    );
  }

  ///
  static showSnackbarSuccess(String message) {
    _showSnackbar(
      "Berhasil",
      message,
      background: Colors.green.shade800,
      foreground: Colors.white,
    );
  }

  ///
  static showSnackbarWarning(String message) {
    _showSnackbar(
      "Peringatan",
      message,
      background: Colors.amber.shade400,
      foreground: Colors.black,
    );
  }

  ///
  static showSnackbarError(String message) {
    _showSnackbar(
      "Error",
      message,
      background: Colors.redAccent.shade700,
      foreground: Colors.white,
    );
  }
}
