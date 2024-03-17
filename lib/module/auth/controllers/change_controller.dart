import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';

class ChangeController {
  final Dio _dio = Dio();
  final String _authRoute = "${PasarAjaConstant.baseUrl}/auth/update";

  Future<DataState<bool>> changePassword({
    required String email,
    required String password,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        "$_authRoute/pw",
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

  Future<DataState<bool>> changePin({
    required String phone,
    required String pin,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        "$_authRoute/pin",
        data: {
          "phone_number": phone,
          "pin": pin,
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

  Future<DataState<bool>> updateDeviceToken({
    required String email,
    required String deviceToken,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        "$_authRoute/devicetoken",
        data: {
          "email": email,
          "device_token": deviceToken,
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

void main(List<String> args) async {
  final controller = await ChangeController().updateDeviceToken(
    email: 'hakiahmad756@gmail.co',
    deviceToken: 'awokawokawok',
  );

  if (controller is DataSuccess) {
    print('berhasil diupdate');
  }

  if (controller is DataFailed) {
    print('gagal diupdate ${controller.error!.error}');
  }
}
