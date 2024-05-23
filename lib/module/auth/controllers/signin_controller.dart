import 'dart:convert';
import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/dio_log.dart';
import 'package:pasaraja_mobile/module/auth/models/shop_model.dart';
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
        // get jwt token
        String jwtToken = payload['data'];

        // save token
        await FlutterSessionJwt.saveToken(jwtToken);
        DMethod.log(
          "expired in : ${await FlutterSessionJwt.getExpirationDateTime()}",
        );

        DMethod.log('decoded jwt');
        // decode jwt
        final decodedToken = JWT.decode(
          jwtToken,
        );

        DMethod.log('return');
        // return user model
        return DataSuccess(UserModel.fromJson(decodedToken.payload['data']));
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
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      DMethod.log('controller : get payload');
      DMethod.log('payload : ${response.data}');
      // get payload
      final Map<String, dynamic> payload = response.data;

      // jika login berhasil
      if (response.statusCode == HttpStatus.ok) {
        DMethod.log('controller : get token');
        // get jwt token
        String jwtToken = payload['data'];

        // save token
        DMethod.log('controller : save token');
        await FlutterSessionJwt.saveToken(jwtToken);
        DMethod.log(
          "expired in : ${await FlutterSessionJwt.getExpirationDateTime()}",
        );

        DMethod.log('controller : decode token');
        // decode jwt
        final decodedToken = JWT.decode(
          jwtToken,
        );

        DMethod.log('controller : return data model');
        // return user model
        return DataSuccess(UserModel.fromJson(decodedToken.payload['data']));
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
        // get jwt token
        String jwtToken = payload['data'];

        // save token
        await FlutterSessionJwt.saveToken(jwtToken);
        DMethod.log(
          "expired in : ${await FlutterSessionJwt.getExpirationDateTime()}",
        );

        // decode jwt
        final decodedToken = JWT.decode(
          jwtToken,
        );

        // return user model
        return DataSuccess(UserModel.fromJson(decodedToken.payload['data']));
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
    // email: 'hakiahmad756@gmail.com',
    // password: 'Haqi.1234',
    phone: '6285655864625',
    pin: "123456",
    deviceName: 'Vivo V2157',
    deviceToken:
        'fIfEGlapRuynzDZxT0JX0M:APA91bE0zuaLLI3kcbVqA3yBbfeXM2yZJS_EnmmRGU1GXG59-2c7xhX71BbkyXX7z1tcWAvP9dCoEOWt0B8sy9HaEX5bJb5UatutK8IrWr0iZMXxmF7971QEcKiILJ0O5ZVQsoPRfYFL',
  );

  if (dataState is DataSuccess) {
    UserModel model = dataState.data as UserModel;
    ShopModel shopModel = model.shopData as ShopModel;
    print('login berhasil ${model.fullName}');
    if (model.level == 'Penjual') {
      print('ID Toko : ${shopModel.idShop}');
      print('Nomor Toko : ${shopModel.phoneNumber}');
      print('Nama Toko : ${shopModel.shopName}');
      print('Deskripsi : ${shopModel.description}');
    }
  }

  if (dataState is DataFailed) {
    print(dataState.error!.error);
  }
}
