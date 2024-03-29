import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';

class AuthController {
  final Dio _dio = Dio();
  final String _authUrl = '${PasarAjaConstant.baseUrl}/auth';

  /// cek apakah email exist atau tidak
  Future<DataState<bool>> isExistEmail({required String email}) async {
    try {
      // send request
      final response = await _dio.get(
        "$_authUrl/cekemail",
        queryParameters: {
          "email": email,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get response data
      final Map<String, dynamic> payload = response.data;

      // jika response ok maka data exist
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
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

  /// cek apakah phone exist atau tidak
  Future<DataState<bool>> isExistPhone({required String phone}) async {
    try {
      // send request
      final response = await _dio.get(
        "$_authUrl/cekphone",
        queryParameters: {
          "phone_number": phone,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get response data
      final Map<String, dynamic> payload = response.data;

      // jika response ok maka data exist
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
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
      PasarAjaUtils.clearDioException(_dio);
      return DataFailed(ex);
    }
  }

  /// Logout akun
  Future<DataState<bool>> logout({required String email}) async {
    try {
      // send request
      final response = await _dio.delete(
        '$_authUrl/logout',
        data: {
          "email": email,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // jika response ok maka logout berhasil
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
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
