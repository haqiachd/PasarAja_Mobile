// ignore_for_file: unused_import

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/complain_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/choose_categories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_detail_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_histories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_settings_model.dart';
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
    required ProductSettingsModel settings,
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
        "settings": '${settings.toJson()}',
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

  Future<DataState<bool>> updateSettingStok({
    required int idShop,
    required int idProduct,
    required bool stokStatus,
  }) async {
    try {
      // request delete
      final response = await _dio.put(
        "$_apiRoute/update/stok",
        data: {
          "id_shop": idShop,
          "id_product": idProduct,
          "stock_status": stokStatus,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.methodNotAllowed;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;
      // print(payload);

      // return status
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

  Future<DataState<bool>> updateSettingRecommended({
    required int idShop,
    required int idProduct,
    required bool recommendedStatus,
  }) async {
    try {
      // request delete
      final response = await _dio.put(
        "$_apiRoute/update/recommended",
        data: {
          "id_shop": idShop,
          "id_product": idProduct,
          "recommended_status": recommendedStatus,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.methodNotAllowed;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;
      // print(payload);

      // return status
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

  Future<DataState<bool>> updateSettingVisibility({
    required int idShop,
    required int idProduct,
    required bool visibilityStatus,
  }) async {
    try {
      // request delete
      final response = await _dio.put(
        "$_apiRoute/update/visibility",
        data: {
          "id_shop": idShop,
          "id_product": idProduct,
          "visibility_status": visibilityStatus,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.methodNotAllowed;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;
      // print(payload);

      // return status
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

  Future<DataState<bool>> deleteProduct({
    required int idShop,
    required int idProduct,
  }) async {
    try {
      // request delete
      final response = await _dio.delete(
        "$_apiRoute/delete",
        data: {
          "id_shop": idShop,
          "id_product": idProduct,
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

  Future<DataState<List<ProductModel>>> allProducts({
    required int idShop,
  }) async {
    try {
      // request api
      final response = await _dio.get(
        "$_apiRoute/",
        queryParameters: {
          "id_shop": idShop,
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
        return DataSuccess(ProductModel.fromList(payload['data']));
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

  Future<DataState<List<ReviewModel>>> detailListReviewPage({
    required int idShop,
    required int idProd,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/drvw",
        queryParameters: {
          "id_shop": idShop,
          "id_product": idProd,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.notFound ||
                status == HttpStatus.badRequest;
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

  Future<DataState<List<ComplainModel>>> detailListComplainPage({
    required int idShop,
    required int idProd,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/dcomp",
        queryParameters: {
          "id_shop": idShop,
          "id_product": idProd,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.notFound ||
                status == HttpStatus.badRequest;
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

  Future<DataState<List<ProductHistoriesModel>>> detailListHistoryPage({
    required int idShop,
    required int idProd,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        "$_pageRoute/dhist",
        queryParameters: {
          "id_shop": idShop,
          "id_product": idProd,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.notFound ||
                status == HttpStatus.badRequest;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return status
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ProductHistoriesModel.fromList(payload['data']));
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

  Future<DataState<List<ChooseCategoriesModel>>> listCategory({
    required int idShop,
  }) async {
    try {
      // request api
      final response = await _dio.get(
        "$_pageRoute/category",
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
        return DataSuccess(ChooseCategoriesModel.fromList(payload['data']));
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

  Future<DataState<List<String>>> getUnits() async {
    try {
      // send request
      final response = await _dio.get(
        "$_apiRoute/units",
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
        // convert to list string
        final List<dynamic> data = payload['data'];
        final List<String> units = data.cast<String>();
        // return data
        return DataSuccess(units);
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

  Future<DataState<bool>> addReview({
    required String orderCode,
    required int idUser,
    required int idShop,
    required int idProduct,
    required String star,
    required String comment,
  }) async {
    try {
      final response = await _dio.post(
        '$_apiRoute/rvw/add',
        data: {
          "order_code": orderCode,
          "id_user": idUser,
          "id_shop": idShop,
          "id_product": idProduct,
          "star": star,
          "comment": comment,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.created ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

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

  Future<DataState<bool>> updateReview({
    required int idReview,
    required int idTrx,
    required int idShop,
    required int idProduct,
    required String star,
    required String comment,
  }) async {
    try {
      final response = await _dio.put(
        '$_apiRoute/rvw/update',
        data: {
          "id_review": idReview,
          "id_trx": idTrx,
          "id_shop": idShop,
          "id_product": idProduct,
          "star": star,
          "comment": comment,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

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

  Future<DataState<bool>> deleteReview({
    required int idReview,
    required int idTrx,
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final response = await _dio.delete(
        '$_apiRoute/rvw/delete',
        data: {
          "id_review": idReview,
          "id_trx": idTrx,
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

      final Map<String, dynamic> payload = response.data;

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

  Future<DataState<bool>> addComplain({
    required String orderCode,
    required int idUser,
    required int idShop,
    required int idProduct,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '$_apiRoute/comp/add',
        data: {
          "order_code": orderCode,
          "id_user": idUser,
          "id_shop": idShop,
          "id_product": idProduct,
          "reason": reason,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.created ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

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

  Future<DataState<bool>> updateComplain({
    required int idComp,
    required int idTrx,
    required int idShop,
    required int idProduct,
    required String reason,
  }) async {
    try {
      final response = await _dio.put(
        '$_apiRoute/comp/update',
        data: {
          "id_complain": idComp,
          "id_trx": idTrx,
          "id_shop": idShop,
          "id_product": idProduct,
          "reason": reason,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

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

  Future<DataState<bool>> deleteComplain({
    required int idComp,
    required int idTrx,
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final response = await _dio.delete(
        '$_apiRoute/comp/delete',
        data: {
          "id_complain": idComp,
          "id_trx": idTrx,
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

      final Map<String, dynamic> payload = response.data;

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

void main(List<String> args) async {
  ProductController productController = ProductController();

  final dataState = await productController.allProducts(idShop: 1);

  if(dataState is DataSuccess){
    print('data berhasil');
    List<ProductModel> prods = dataState.data as List<ProductModel>;
    for(var prod in prods){
      print('name : ${prod.productName}');
    }
  }

  if(dataState is DataFailed){
    print('data gagal : ${dataState.error?.error}');
  }
}
