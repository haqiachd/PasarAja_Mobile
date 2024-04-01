// ignore_for_file: unused_field

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';

class PromoController {
  final Dio _dio = Dio();
  final String _pageRoute = '${PasarAjaConstant.baseUrl}/page/merchant/promo';
  final String _apiRoute = '${PasarAjaConstant.baseUrl}/prod/promo';

  Future<DataState<List<PromoModel>>> fetchActivePromo(
      {required int idShop}) async {
    try {
      // get response
      final response = await _dio.get(
        "$_apiRoute/",
        queryParameters: {
          "id_shop": idShop,
          "type": "active",
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(PromoModel.fromList(payload['data']));
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

  Future<DataState<List<PromoModel>>> fetchSoonPromo(
      {required int idShop}) async {
    try {
      // get response
      final response = await _dio.get(
        "$_apiRoute/",
        queryParameters: {
          "id_shop": idShop,
          "type": "soon",
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(PromoModel.fromList(payload['data']));
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

  Future<DataState<List<PromoModel>>> fetchExpiredPromo(
      {required int idShop}) async {
    try {
      // get response
      final response = await _dio.get(
        "$_apiRoute/",
        queryParameters: {
          "id_shop": idShop,
          "type": "expired",
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(PromoModel.fromList(payload['data']));
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
  PromoController controller = PromoController();
  final dataState = await controller.fetchExpiredPromo(
    idShop: 1,
  );

  if (dataState is DataSuccess) {
    for (var data in dataState.data as List<PromoModel>) {
      print(data.productName);
    }
  }

  if (dataState is DataFailed) {
    print('data failed');
  }
}
