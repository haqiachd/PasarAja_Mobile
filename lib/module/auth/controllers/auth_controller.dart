import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/data/data_state.dart';

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

      // jika response ok maka data exist
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return const DataSuccess(false);
      }
    } on DioError catch (ex) {
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

      // jika response ok maka data exist
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return const DataSuccess(false);
      }
    } on DioError catch (ex) {
      return DataFailed(ex);
    }
  }
}
