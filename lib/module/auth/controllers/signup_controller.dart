import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';

class SignUpController {
  final Dio _dio = Dio();
  final String _signUpRoute = '${PasarAjaConstant.baseUrl}/auth';
  Future<DataState<bool>> signUp({
    required String phone,
    required String email,
    required String fullName,
    required String pin,
    required String password,
  }) async {
    try {
      // send request
      final response = await _dio.post(
        "$_signUpRoute/signup/",
        data: {
          "phone_number": phone,
          "email" : email,
          "full_name": fullName,
          "pin": pin,
          "password": password,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        // jika register success
        return const DataSuccess(true);
      } else {
        // jika register gagal
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'],
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }
}
