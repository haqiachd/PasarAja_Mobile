import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/auth/models/verification_model.dart';

class VerificationController {
  final Dio _dio = Dio();
  final String _verifyRoute = '${PasarAjaConstant.baseUrl}/verify';
  // type
  static const registerVerify = 'Register';
  static const forgotVerify = 'Forgot';

  Future<DataState<VerificationModel>> requestOtp({
    required String email,
    required String type,
  }) async {
    try {
      // send request
      final response = await _dio.post(
        "$_verifyRoute/otp",
        data: {
          "email": email,
          "type": type,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(VerificationModel.fromJson(payload['data']));
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

  Future<DataState<VerificationModel>> requestOtpByPhone({
    required String phone,
    required String type,
  }) async {
    try {
      // send request
      final response = await _dio.post(
        "$_verifyRoute/otpbyphone",
        data: {
          "phone_number": phone,
          "type": type,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(VerificationModel.fromJson(payload['data']));
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
      print('exception $ex');
      return DataFailed(ex);
    }
  }
}

void main(List<String> args) async {
  VerificationController verificationController = VerificationController();
  DataState dataState = await verificationController.requestOtpByPhone(
    // email: "arenafinder.app@gmail.com",
    phone: '6285655864624',
    type: VerificationController.forgotVerify,
  );

  if (dataState is DataSuccess) {
    var verify = dataState.data as VerificationModel;
    print('OTP is : ${verify.otp}');
  }

  if (dataState is DataFailed) {
    print(dataState.error!.error);
  }
}
