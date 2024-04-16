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

  Future<DataState<bool>> isPromo({
    required int? idShop,
    required int? idProduct,
    required String? type,
  }) async {
    try {
      final response = await _dio.get(
        '$_apiRoute/ispromo',
        queryParameters: {
          'id_shop': idShop,
          'id_product': idProduct,
          'type': type,
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

  Future<DataState<bool>> createPromo({
    required int? idShop,
    required int? idProduct,
    required int? promoPrice,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    try {
      final response = await _dio.post(
        '$_apiRoute/create',
        data: {
          'id_shop': idShop,
          'id_product': idProduct,
          'promo_price': promoPrice,
          'start_date': startDate?.toIso8601String().substring(0, 10),
          'end_date': endDate?.toIso8601String().substring(0, 10),
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.created ||
                status == HttpStatus.badRequest;
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

  Future<DataState<bool>> updatePromo({
    required int? idShop,
    required int? idPromo,
    required int? promoPrice,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    try {
      final response = await _dio.put(
        '$_apiRoute/update',
        data: {
          'id_shop': idShop,
          'id_promo': idPromo,
          'promo_price': promoPrice,
          'start_date': startDate?.toIso8601String().substring(0, 10),
          'end_date': endDate?.toIso8601String().substring(0, 10),
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
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

  Future<DataState<bool>> deletePromo({
    required int? idShop,
    required int? idPromo,
  }) async {
    try {
      final response = await _dio.delete(
        '$_apiRoute/delete',
        data: {
          'id_shop': idShop,
          'id_promo': idPromo,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
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

  Future<DataState<PromoModel>> detailPromo({
    required int? idShop,
    required int? idPromo,
  }) async {
    try {
      // call response
      final response = await _dio.get(
        '$_apiRoute/detail',
        queryParameters: {
          "id_shop": idShop,
          "id_promo": idPromo,
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
      final Map<String, dynamic> payload = await response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(PromoModel.fromJson(payload['data']));
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
  // PromoController controller = PromoController();
  //
  // final detail = await controller.detailPromo(
  //   idShop: 1,
  //   idPromo: 2,
  // );
  //
  // if (detail is DataSuccess) {
  //   PromoModel promo = detail.data as PromoModel;
  //   print(promo.productName);
  // }
  //
  // if (detail is DataFailed) {
  //   print('error');
  // }

  // final cek = await controller.isPromo(
  //   idShop: 1,
  //   idProduct: 4,
  //   type: 'soon',
  // );

  // if (cek is DataSuccess) {
  //   print('produk dalam promo');
  // }

  // if (cek is DataFailed) {
  //   print('produk tidak dalam promo');
  // }

  // final created = await controller.createPromo(
  //   idShop: 1,
  //   idProduct: 6,
  //   promoPrice: 5000,
  //   startDate: DateTime(2024, 4, 10),
  //   endDate: DateTime(2024, 4, 20),
  // );

  // if (created is DataSuccess) {
  //   print('promo ditambahkan');
  // }

  // if (created is DataFailed) {
  //   print('promo gagal ditambahkan');
  //   print('error : ${created.error?.error}');
  // }

  // final update = await controller.updatePromo(
  //   idShop: 1,
  //   idPromo: 21,
  //   promoPrice: 10000,
  //   startDate: DateTime(2024, 4, 13),
  //   endDate: DateTime(2024, 4, 20),
  // );

  // if (update is DataSuccess) {
  //   print('promo diupdate');
  // }

  // if (update is DataFailed) {
  //   print('promo gagal diupdate');
  //   print('error : ${update.error?.error}');
  // }

  // final hapus = await controller.deletePromo(
  //   idShop: 1,
  //   idPromo: 1,
  // );

  // if (hapus is DataSuccess) {
  //   print('promo berhasil dihapus');
  // }

  // if (hapus is DataFailed) {
  //   print('promo gagal dihapus');
  // }

  // print('end of test');
  // return;

  // final dataState = await controller.fetchExpiredPromo(
  //   idShop: 1,
  // );

  // if (dataState is DataSuccess) {
  //   for (var data in dataState.data as List<PromoModel>) {
  //     print(data.productName);
  //   }
  // }

  // if (dataState is DataFailed) {
  //   print('data failed');
  // }
}
