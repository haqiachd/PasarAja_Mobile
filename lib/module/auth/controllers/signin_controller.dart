import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/dio_log.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';

class SignInController {
  final Dio _dio = Dio();
  final String _signInRoute = '${PasarAjaConstant.baseUrl}/auth/signin';

  /// login dengan google
  Future<DataState> signInGoogle({
    required String email,
    required String deviceName,
    required String deviceToken,
  }) async {
    try {
      DioLogger.showDioException(_dio);
      // send request
      final response = await _dio.post(
        "$_signInRoute/google",
        data: {
          "email": email,
          "device_name": deviceName,
          "device_token": deviceToken,
        },
        options: Options(
          // accepted status
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // jika success maka akan mengembalikan data dari reponse
      if (response.statusCode == HttpStatus.ok) {
        // decode jwt
        String jwtToken = payload['data'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);

        return DataSuccess(UserModel.fromJson(decodedToken['data'][0]));
      } else {
        // jika gagal maka akan mengembalikan pesan error
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'],
          ),
        );
      }
    } on DioException catch (error) {
      return DataFailed(error);
    }
  }

  /// login dengan email
  Future<DataState<UserModel>> signInEmail({
    required String email,
    required String password,
    required String deviceName,
    required String deviceToken,
  }) async {
    try {
      DioLogger.showDioException(_dio);
      // send request
      final response = await _dio.post(
        "$_signInRoute/email",
        data: {
          "email": email,
          "password": password,
          "device_name": deviceName,
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

      // jika login berhasil
      if (response.statusCode == HttpStatus.ok) {
        // decode jwt
        String jwtToken = payload['data'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);

        return DataSuccess(UserModel.fromJson(decodedToken['data'][0]));
      } else {
        // jika login gagal
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

  /// login dengan nomor hp
  Future<DataState<UserModel>> signInPhone({
    required String phone,
    required String pin,
    required String deviceName,
    required String deviceToken,
  }) async {
    try {
      DioLogger.showDioException(_dio);
      // send request
      final response = await _dio.post(
        "$_signInRoute/phone",
        data: {
          "phone_number": phone,
          "pin": pin,
          "device_name": deviceName,
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

      // jika login berhasil
      if (response.statusCode == HttpStatus.ok) {
        // decode jwt
        String jwtToken = payload['data'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);

        return DataSuccess(UserModel.fromJson(decodedToken['data'][0]));
      } else {
        // jika login gagal
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
  DataState dataState = await SignInController().signInPhone(
    // email: 'hakiahmad756@gmail.coms',
    // password: 'Haqi.1234',
    phone: '628565586462s',
    pin: "123456",
    deviceName: 'Vivo V2157',
    deviceToken:
        'fIfEGlapRuynzDZxT0JX0M:APA91bE0zuaLLI3kcbVqA3yBbfeXM2yZJS_EnmmRGU1GXG59-2c7xhX71BbkyXX7z1tcWAvP9dCoEOWt0B8sy9HaEX5bJb5UatutK8IrWr0iZMXxmF7971QEcKiILJ0O5ZVQsoPRfYFL',
  );

  if (dataState is DataSuccess) {
    UserModel model = dataState.data as UserModel;
    print('login berhasil ${model.fullName}');
  }

  if (dataState is DataFailed) {
    print(dataState.error!.error);
  }
}
