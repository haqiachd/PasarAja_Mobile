import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
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
      DMethod.log('Perangkat tidak mendukung getaran.');
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

  static String addZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  static String formatPrice(int price) {
  return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]},',
      );
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
