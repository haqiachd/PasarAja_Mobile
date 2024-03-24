import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/highest_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_category_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class ProductController {
  final Dio _dio = Dio();
  final String _routeUrl = '${PasarAjaConstant.baseUrl}/page/merchant/prod';

  Future<DataState<ProductPageModel>> productPage({
    required int idShop,
    int? limit,
  }) async {
    try {
      // request api
      final response = await _dio.get(
        "$_routeUrl/",
        queryParameters: {
          "id_shop": idShop,
          "limit": limit,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return hasil response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(
          ProductPageModel.fromJson(payload['data']),
        );
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
  ProductController productController = ProductController();

  DataState dataState = await productController.productPage(idShop: 1);

  if (dataState is DataSuccess) {
    ProductPageModel page = dataState.data as ProductPageModel;

    print("DATA KATEGORY");
    for (ProductCategoryModel ctg in page.categories ?? []) {
      print('product name : ${ctg.categoryName}');
    }

    print("DATA PRODUK");
    for (ProductModel prod in page.products ?? []) {
      print('product name : ${prod.productName}');
    }

    print("DATA PRODUK RATING TERTINGGI");
    for (HighestModel prod in page.highest ?? []) {
      print('product name : ${prod.productName} --> ${prod.rating}');
    }

    print("DATA PRODUK TERLARIS");
    for (ProductModel prod in page.sellings ?? []) {
      print('product name : ${prod.productName} --> ${prod.totalSold}');
    }

    print('success');
  }

  if (dataState is DataFailed) {
    print('error ${dataState.error!.error.toString()}');
  }
}
