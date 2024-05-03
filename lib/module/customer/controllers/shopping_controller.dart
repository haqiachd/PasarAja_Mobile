import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/customer/models/product_categories_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_detail_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class ShoppingController {
  final _dio = Dio();
  String _shopData = '${PasarAjaConstant.baseUrl}/shop';
  final String _userProd = '${PasarAjaConstant.baseUrl}/uprod';

  Future<DataState<List<ShopDataModel>>> fetchShopData() async {
    _shopData = _shopData.replaceAll('/m', '');

    try {
      final response = await _dio.get(
        '$_shopData/list',
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.notFound;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ShopDataModel.toList(payload['data']));
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: 'Server Not Found',
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<List<ProductModel>>> fetchProdData() async {
    try {
      final response = await _dio.get(
        '$_userProd/list',
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.notFound;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductModel.fromList(payload['data']));
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: 'Server Not Found',
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<ProductDetailModel>> fetchProdDetail({
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final response = await _dio.get(
        '$_userProd/detail',
        queryParameters: {
          "id_shop": idShop,
          "id_product": idProduct,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.notFound ||
                status == HttpStatus.badRequest;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductDetailModel.fromJson(payload['data']));
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['error'],
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<List<ProductCategoryModel>>> fetchCategoriesData() async {
    try {
      final response = await _dio.get(
        '$_userProd/ctg',
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.notFound;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductCategoryModel.fromList(payload['data']));
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['error'],
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

}

void main() async {
  ShoppingController controller = ShoppingController();

  // final dataState = await controller.fetchShopData();
  //
  // if(dataState is DataSuccess){
  //   var shops = dataState.data as List<ShopDataModel>;
  //   for(var shop in shops){
  //     print('data :  ${shop.shopName}');
  //   }
  // }
  //
  // if(dataState is DataFailed){
  //   print('error : ${dataState.error?.error}');
  // }

  // final dataState = await controller.fetchProdData();
  //
  // if (dataState is DataSuccess) {
  //   var shops = dataState.data as List<ProductModel>;
  //   for (var shop in shops) {
  //     print('data :  ${shop.productName}');
  //   }
  // }
  //
  // if (dataState is DataFailed) {
  //   print('error : ${dataState.error?.error}');
  // }

  final dataState = await controller.fetchProdDetail(idShop: 1, idProduct: 2);

  if(dataState is DataSuccess){
    var prod = dataState.data as ProductDetailModel;
    print('nama toko : ${prod.shopData?.shopName}');
    print('rating : ${prod.reviews?.rating} (${prod.reviews?.totalReview} ulasan)');
    var reviews = dataState.data?.reviews?.reviewers ?? [];
    for(var rvw in reviews){
      print('user : ${rvw.fullName}');
      print('user : ${rvw.star}');
      print('user : ${rvw.comment}');
    }
  }
  if (dataState is DataFailed) {
    print('error : ${dataState.error?.error}');
  }

  // final dataState = await controller.fetchCategoriesData();
  //
  // if(dataState is DataSuccess){
  //   var ctgs = dataState.data as List<ProductCategoryModel>;
  //
  //   for(var ctg in ctgs){
  //     print(ctg.categoryName);
  //   }
  // }
  //
  // if (dataState is DataFailed) {
  //   print('error : ${dataState.error?.error}');
  // }

}
