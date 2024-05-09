import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/customer/models/page/beranda_page_model.dart';
import 'package:pasaraja_mobile/module/customer/models/page/promo_page_model.dart';
import 'package:pasaraja_mobile/module/customer/models/page/shop_detail_model.dart';

class CustomerPageController {
  final Dio _dio = Dio();
  final String _apiPage = "${PasarAjaConstant.baseUrl}/page/customer";

  Future<DataState<BerandaModel>> homepage() async {
    try {
      final response = await _dio.get(
        "$_apiPage/home",
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.internalServerError ||
                status == HttpStatus.badRequest;
          },
        ),
      );

      Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(BerandaModel.fromJson(payload['data']));
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

  Future<DataState<ShopDetailModel>> shopData({required int idShop}) async {
    try {
      final response = await _dio.get(
        "$_apiPage/shop",
        queryParameters: {
          "id_shop" : idShop,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.internalServerError ||
                status == HttpStatus.badRequest;
          },
        ),
      );

      Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ShopDetailModel.fromJson(payload['data']));
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

  Future<DataState<PromoPageModel>> promoData() async {
    try {
      final response = await _dio.get(
        "$_apiPage/promo",
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.internalServerError ||
                status == HttpStatus.badRequest;
          },
        ),
      );

      Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(PromoPageModel.fromJson(payload['data']));
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

void main() async {
  final cont = CustomerPageController();

  final dataState = await cont.promoData();

  if(dataState is DataSuccess){
    var data = dataState.data;
    //
    // print('shop name : ${data?.shop?.shopName}');
    //
    // print('lenth : ${data!.products!.length}');

    for(var prod in data!.categories!){
      print('ctg cont : ${prod.categoryName}');
    }
  }
  //
  if(dataState is DataFailed){
    print('data falield : ${dataState.error?.error ?? 'null'}');
  }
}
