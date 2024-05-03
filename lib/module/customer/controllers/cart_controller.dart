import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class CartController {
  final Dio _dio = Dio();
  final String _apiUserTrx = "${PasarAjaConstant.baseUrl}/utrx/cart";

  Future<DataState<List<CartModel>>> fetchListCart({
    required int idUser,
  }) async {
    try {
      final response = await _dio.get(
        "$_apiUserTrx/",
        queryParameters: {
          "id_user": idUser,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(CartModel.fromList(payload['data']));
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

  Future<DataState<bool>> addCart({
    required int idUser,
    required int idShop,
    required ProductModel product,
    required int quantity,
    required String notes,
    required int promoPrice,
  }) async {
    try {
      final response = await _dio.post(
        "$_apiUserTrx/add",
        data: {
          "id_user": idUser,
          "id_shop": idShop,
          "id_product": product.id,
          "quantity": quantity,
          "promo_price": promoPrice,
          "notes": notes,
          "product_data": product.toJson(),
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      Map<String, dynamic> payload = response.data;

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

  Future<DataState<bool>> removeCart({
    required int idUser,
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final response = await _dio.delete(
        "$_apiUserTrx/delete",
        data: {"id_user": idUser, "id_shop": idShop, "id_product": idProduct},
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      Map<String, dynamic> payload = response.data;

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

void main() async {
  final CartController controller = CartController();

  // final dataState = await controller.fetchListCart(idUser: 1);
  //
  // if(dataState is DataSuccess){
  //   var data = dataState.data as List<CartModel>;
  //
  //   for(var d in data){
  //     print(d.shopDataModel?.shopName);
  //   }
  // }
  //
  // if(dataState is DataFailed){
  //   print('data failed : ${dataState.error?.error}');
  // }

  // var product =
  //     const ProductModel(idProduct: 2, productName: 'Sate', price: 100);
  //
  // final dataState = await controller.addCart(
  //   idUser: 1,
  //   idShop: 1,
  //   product: product,
  //   quantity: 1,
  //   notes: 'dsfsaf',
  //   promoPrice: 200,
  // );
  //
  // if(dataState is DataSuccess){
  //   print('cart ditambahkan');
  // }
  //
  // if (dataState is DataFailed) {
  //   print('data failed : ${dataState.error?.error}');
  // }

  // final dataState = await controller.removeCart(
  //   idUser: 1,
  //   idShop: 1,
  //   idProduct: 3,
  // );
  //
  // if(dataState is DataSuccess){
  //   print('cart dihapus');
  // }
  //
  // if (dataState is DataFailed) {
  //   print('data failed : ${dataState.error?.error}');
  // }
}
