import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class DioLogger {
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

}
