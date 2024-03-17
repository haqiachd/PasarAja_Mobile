import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:vibration/vibration.dart';

class PasarAjaUtils {
  static final RegExp regexNum = RegExp(r'[0-9]');

  static bool containsNumber(String text) {
    return regexNum.hasMatch(text);
  }

  static Future<void> triggerVibration() async {
    bool? hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 500);
    } else {
      print('Perangkat tidak mendukung getaran.');
    }
  }

  static showDioException(
    Dio dio, {
    bool responseData = false,
    bool requestData = false,
    bool responseHeaders = false,
    bool requestHeaders = false,
    bool responseMessage = false,
  }) {
    dio.interceptors.add(
      TalkerDioLogger(
        settings: TalkerDioLoggerSettings(
          // All http request & responses enabled for console logging
          printResponseData: responseData,
          printRequestData: requestData,
          // Request & Reposnse logs including http - headers
          printResponseHeaders: responseHeaders,
          printRequestHeaders: requestHeaders,
          // Request logs with response message
          printResponseMessage: responseMessage,
        ),
      ),
    );
  }

  static clearDioException(Dio dio) {
    dio.interceptors.clear();
  }

  static showMessage(
    String title,
    String message, {
    Color? background,
    Color? foreground,
  }) {
    Get.snackbar(
      'Peringatan',
      message.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: background,
      colorText: foreground,
      borderRadius: 10,
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.startToEnd,
      overlayColor: Colors.white.withOpacity(0.5),
      barBlur: 20,
      overlayBlur: 0.2,
      onTap: (snack) {
        Get.back();
      },
    );
  }

  static showWarning(String message) {
    showMessage(
      "Peringatan",
      message,
      background: Colors.amber,
      foreground: Colors.black,
    );
  }

  static showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
      barrierDismissible: false,
    );
  }

  static dynamic showConfirmBack(String message) {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Wrap(
          children: [
            ListTile(
              title: Text(message),
              onTap: () {
                Get.back(result: true);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Iya'),
              onTap: () {
                Get.back(result: true);
              },
            ),
            ListTile(
              title: const Text('Tidak'),
              onTap: () {
                Get.back(result: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  static String addZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  static Future<String> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.brand} ${androidInfo.model}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.productName;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      return macInfo.model;
    } else {
      return 'Unknown';
    }
  }
}
