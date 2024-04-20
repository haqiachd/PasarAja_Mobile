import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';

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

  /// update photo profile
  Future<DataState<String>> updatePhotoProfile({
    required String email,
    required File newPhoto,
  }) async {
    try {
      // create form
      FormData formData = FormData.fromMap({
        "email": email,
        "photo":
            await MultipartFile.fromFile(newPhoto.path, filename: 'product.png')
      });

      // call response
      final response = await _dio.post(
        '$_authUrl/update/pp',
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.notFound ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;
      DMethod.log("PAYLOAD : $payload");

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(payload['data']['photo']);
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

  Future<DataState<UserModel>> updateAccount({
    required String email,
    required String fullName,
  }) async {
    try {
      // request api
      final response = await _dio.put(
        '$_authUrl/update/acc',
        data: {
          "email": email,
          "full_name" : fullName,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(UserModel.fromJson(payload['data']));
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

  /// hapus foto profile
  Future<DataState<String>> deletePhotoProfile({
    required String email,
  }) async {
    try {
      // send request
      DMethod.log('cont : prepare -> $email');
      final response = await _dio.delete(
        '$_authUrl/delpp',
        data: {
          "email": email,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.notFound ||
                status == HttpStatus.badRequest;
          },
        ),
      );

      DMethod.log('cont : get payload');
      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        DMethod.log('cont : on success');
        return DataSuccess(payload['data']['photo']);
      } else {
        DMethod.log('cont : on error');
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
