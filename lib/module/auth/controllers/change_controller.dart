import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';

class ChangeController {
  final Dio _dio = Dio();
  final String _authRoute = "${PasarAjaConstant.baseUrl}/auth";
  Future<DataState<bool>> changePassword({
    required String email,
    required String password,
  }) async {
    try {
      // send request
      final response = await _dio.post(
        "$_authRoute/updatepw",
        data: {
          "email": email,
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
        // jika pw berhasil diubah
        return const DataSuccess(true);
      } else {
        // jika pw gagal diubah
        return DataFailed(
          DioError(
            requestOptions: response.requestOptions,
            response: response,
            type: DioErrorType.response,
            error: payload['message'],
          ),
        );
      }
    } on DioError catch (ex) {
      return DataFailed(ex);
    }
  }
}

