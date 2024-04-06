// ignore_for_file: unused_field, unused_import
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_transaction_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_detail_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';

class OrderController {
  final Dio _dio = Dio();
  final String _routeUrl = '${PasarAjaConstant.baseUrl}/trx';
  final String _pageUrl = '${PasarAjaConstant.baseUrl}/page/merchant/trx';

  Future<DataState<List<TransactionModel>>> lisfOfTrx({
    required int idShop,
    required String status,
  }) async {
    try {
      // request api
      final response = await _dio.get(
        '$_pageUrl/',
        queryParameters: {
          "id_shop": idShop,
          "status": status,
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

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(TransactionModel.fromList(payload['data']));
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

  Future<DataState<List<TransactionModel>>> tabRequest({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "Request");
  }

  Future<DataState<List<TransactionModel>>> tabCancelByCustomer({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "Cancel_Customer");
  }

  Future<DataState<List<TransactionModel>>> tabCancelByMerchant({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "Cancel_Merchant");
  }

  Future<DataState<List<TransactionModel>>> tabConfirmed({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "Confirmed");
  }

  Future<DataState<List<TransactionModel>>> tabInTaking({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "InTaking");
  }

  Future<DataState<List<TransactionModel>>> tabSubmitted({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "Submitted");
  }

  Future<DataState<List<TransactionModel>>> tabFinished({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "Finished");
  }

  Future<DataState<List<TransactionModel>>> tabExpired({
    required int idShop,
  }) async {
    return await lisfOfTrx(idShop: idShop, status: "Expired");
  }

  Future<DataState<bool>> createTrx({
    required int idShop,
    required int idUser,
    required String email,
    required DateTime takenDate,
    required List<ProductTransactionModel> products,
  }) async {
    try {
      // send request
      final response = await _dio.post(
        '$_routeUrl/crtrx',
        data: {
          "id_shop": idShop,
          "id_user": idUser,
          "email": email,
          "taken_date": takenDate.toIso8601String().substring(0, 10),
          "products": ProductTransactionModel.toJsonList(products)['products'],
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.created ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.created) {
        return const DataSuccess(true);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'].toString(),
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<bool>> cancelByCustomerTrx({
    required int idShop,
    required String orderCode,
    required String reason,
    required String message,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '$_routeUrl/cbcus',
        data: {
          "id_shop": idShop,
          "order_code": orderCode,
          "reason": reason,
          "message": message,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'].toString(),
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<bool>> cancelByMerchantTrx({
    required int idShop,
    required String orderCode,
    required String reason,
    required String message,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '$_routeUrl/cbmer',
        data: {
          "id_shop": idShop,
          "order_code": orderCode,
          "reason": reason,
          "message": message,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'].toString(),
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<bool>> confirmTrx({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '$_routeUrl/cftrx',
        data: {
          "id_shop": idShop,
          "order_code": orderCode,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'].toString(),
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<bool>> inTakingTrx({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '$_routeUrl/ittrx',
        data: {
          "id_shop": idShop,
          "order_code": orderCode,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'].toString(),
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<bool>> submittedTrx({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '$_routeUrl/sbtTrx',
        data: {
          "id_shop": idShop,
          "order_code": orderCode,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'].toString(),
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }

  Future<DataState<bool>> finishTrx({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '$_routeUrl/fstrx',
        data: {
          "id_shop": idShop,
          "order_code": orderCode,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok ||
                status == HttpStatus.badRequest ||
                status == HttpStatus.notFound ||
                status == HttpStatus.internalServerError;
          },
        ),
      );

      // get payload
      final Map<String, dynamic> payload = response.data;

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return const DataSuccess(true);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'].toString(),
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }
}

void main(List<String> args) async {
  OrderController controller = OrderController();

  final update = await controller.finishTrx(
    idShop: 1,
    orderCode: "PasarAja-749a8261-696d-4739-8f53-f5d3f51a366a",
    // reason: "Stok nya sudah habis!",
    // message: "Mohon maaf stok-nya sudah habis :)",
  );

  if (update is DataSuccess) {
    print('data success');
  }

  if (update is DataFailed) {
    print('data failed : ${update.error?.error}');
  }

  // List<ProductTransactionModel> products = [
  //   const ProductTransactionModel(
  //       idProduct: 2, quantity: 2, promoPrice: 10, notes: ''),
  //   const ProductTransactionModel(
  //       idProduct: 1, quantity: 2, promoPrice: 2000, notes: 'sambalnya dipisah')
  // ];

  // final test = await controller.createTrx(
  //   idShop: 1,
  //   idUser: 3,
  //   email: 'e41222905@student.polije.ac.id',
  //   takenDate: DateTime(2024, 04, 7),
  //   products: products,
  // );

  // if (test is DataSuccess) {
  //   print('data success');
  // }

  // if (test is DataFailed) {
  //   print('data failed : ${test.error?.error}');
  // }

  // return;

  // final state = await controller.tabRequest(
  //   idShop: 1,
  // );

  // if (state is DataSuccess) {
  //   List<TransactionModel> trxs = state.data as List<TransactionModel>;
  //   for (var trx in trxs) {
  //     print(trx.orderCode);
  //     for (var dtl in trx.details as List<TransactionDetailModel>) {
  //       print(' --> ${dtl.productName}');
  //     }
  //   }
  //   print('data success');
  // }

  // if (state is DataFailed) {
  //   print('data failed : ${state.error?.error}');
  // }
}
