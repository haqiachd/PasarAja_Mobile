// ignore_for_file: unused_import

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/complain_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_detail_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_histories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/review_model.dart';

class ProductController {
  final Dio _dio = Dio();
  final String _pageRoute = '${PasarAjaConstant.baseUrl}/page/merchant/prod';
  final String _apiRoute = '${PasarAjaConstant.baseUrl}/prod';

  Future<DataState<bool>> addProduct({
    required int idShop,
    required int idCategory,
    required String productName,
    required String description,
    required String unit,
    required int sellingUnit,
    required File photo,
    required int price,
  }) async {
    try {
      // Create FormData
      FormData formData = FormData.fromMap({
        "id_shop": idShop,
        "id_cp_prod": idCategory,
        "product_name": productName,
        "description": description,
        "unit": unit,
        "selling_unit": sellingUnit,
        "photo":
            await MultipartFile.fromFile(photo.path, filename: 'product.png'),
        "price": price,
      });

      // send request
      final response = await _dio.post(
        "$_apiRoute/create",
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.created ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.internalServerError ||
                status == HttpStatus.ok;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.created) {
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

  Future<DataState<bool>> updateeProduct({
    required int idShop,
  }) async {
    return const DataSuccess(true);
  }

  Future<DataState<bool>> deleteProductt({
    required int idShop,
  }) async {
    return const DataSuccess(true);
  }

  Future<DataState<ProductDetailModel>> detailProductPage({
    required int idShop,
    required int idProd,
  }) async {
    try {
      // request api
      final response = await _dio.get(
        "$_pageRoute/detail",
        queryParameters: {
          "id_shop": idShop,
          "id_product": idProd,
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
        return DataSuccess(ProductDetailModel.fromJson(payload['data']));
      } else {
        return DataFailed(
          DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              error: payload['message']),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<ProductModel>> dataProduct({
    required int idShop,
    required int idProduct,
  }) async {
    try {
      // request api
      final response = await _dio.get(
        "$_apiRoute/data",
        queryParameters: {
          "id_shop": idShop,
          "id_product": idProduct,
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

      // return hasil response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(
          ProductModel.fromJson(payload['data']),
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

  Future<DataState<ProductPageModel>> productPage({
    required int idShop,
    int? limit,
  }) async {
    try {
      // request api
      final response = await _dio.get(
        "$_pageRoute/",
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

  Future<DataState<List<ProductModel>>> bestSellingPage({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/selling",
        queryParameters: {
          "id_shop": idShop,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductModel.fromList(payload['data']));
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

  Future<DataState<List<ReviewModel>>> reviewPage({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/rvw",
        queryParameters: {
          "id_shop": idShop,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ReviewModel.fromList(payload['data']));
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

  Future<DataState<List<ComplainModel>>> complainPage({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/comp",
        queryParameters: {
          "id_shop": idShop,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ComplainModel.fromList(payload['data']));
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

  Future<DataState<List<ProductModel>>> unavailablePage({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/unavl",
        queryParameters: {
          "id_shop": idShop,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductModel.fromList(payload['data']));
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

  Future<DataState<List<ProductModel>>> hiddenPage({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/hidden",
        queryParameters: {
          "id_shop": idShop,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductModel.fromList(payload['data']));
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

  Future<DataState<List<ProductModel>>> recommendedPage({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/recommended",
        queryParameters: {
          "id_shop": idShop,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductModel.fromList(payload['data']));
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

  final dataState = await productController.dataProduct(
    idShop: 1,
    idProduct: 1,
  );

  if (dataState is DataSuccess) {
    ProductModel model = dataState.data as ProductModel;
    print('Data Success');
    print("Nama : ${model.productName}");
  }

  if (dataState is DataFailed) {
    print("Data Failed : ${dataState.error}");
  }
}
