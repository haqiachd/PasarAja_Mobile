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
    // dio.interceptors.clear();
  }
}
