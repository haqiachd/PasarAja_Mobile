import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';

class OrderController {
  final Dio _dio = Dio();
  final String _apiUserTrx = "${PasarAjaConstant.baseUrl}/utrx";
  final String _apiShopTrx = "${PasarAjaConstant.baseUrl}/trx";

  Future<DataState<TransactionHistoryModel>> dataTrx({
    required String email,
    required String orderCode,
  }) async {
    try {
      final response = await _dio.get(
        '$_apiUserTrx/data',
        queryParameters: {
          "email": email,
          "order_code": orderCode,
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
        return DataSuccess(TransactionHistoryModel.fromJson(payload['data']));
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

  Future<DataState<List<TransactionHistoryModel>>> _listOfTrx({
    required String email,
    required String type,
  }) async {
    try {
      // call api
      final response = await _dio.get(
        '$_apiUserTrx/list',
        queryParameters: {
          "email": email,
          "type": type,
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
        return DataSuccess(TransactionHistoryModel.toList(payload['data']));
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

  Future<DataState<List<TransactionHistoryModel>>> tabRequest({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Request");
  }

  Future<DataState<List<TransactionHistoryModel>>> tabConfirmed({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Confirmed");
  }

  Future<DataState<List<TransactionHistoryModel>>> tabInTaking({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "InTaking");
  }

  Future<DataState<List<TransactionHistoryModel>>> tabSubmitted({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Submitted");
  }

  Future<DataState<List<TransactionHistoryModel>>> tabFinished({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Finished");
  }

  Future<DataState<List<TransactionHistoryModel>>> tabCancelByCustomer({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Cancel_Customer");
  }

  Future<DataState<List<TransactionHistoryModel>>> tabCancelByMerchant({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Cancel_Merchant");
  }

  Future<DataState<List<TransactionHistoryModel>>> tabExpired({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Expired");
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
        '$_apiShopTrx/cbcus',
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

  Future<DataState<bool>> inTakingTrx({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '$_apiShopTrx/ittrx',
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
        '$_apiShopTrx/fstrx',
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

void main() async {
  OrderController _controller = OrderController();

  // final dataState = await _controller.tabCancelByMerchant(
  //     email: "e41222905@student.polije.ac.id");

  // if (dataState is DataSuccess) {
  //   List<TransactionHistoryModel> orders =
  //       dataState.data as List<TransactionHistoryModel>;
  //
  //   for (var order in orders) {
  //     print('ORDER CODE : ${order.orderCode}');
  //     print("NAMA TOKO : ${order.shopData?.shopName}");
  //     print("TANGGAL PESAN : ${order.createdAt}");
  //     print("DETAIL -->");
  //     List<TransactionDetailHistoryModel> details =
  //         order.details as List<TransactionDetailHistoryModel>;
  //     for (var detail in details) {
  //       print("\tNAMA PRODUCT : ${detail.product?.productName}");
  //       print("\tHARGA : ${detail.price}");
  //       print("\tRATING : ${detail.product?.rating}");
  //       print("\tTOTAL REVIEW : ${detail.product?.totalReview}");
  //       // print("\tQUANTITY : ${detail.quantity}");
  //       // print("\tTOTAL PROMO : ${detail.promoPrice}");
  //       print("\tTOTAL HARGA : ${detail.totalPrice}");
  //       print('\t-');
  //     }
  //     print('-------------------');
  //   }
  // }
  //
  // if (dataState is DataFailed) {
  //   print('ERROR : ${dataState.error?.error}');
  // }

  final dataTrx = await _controller.dataTrx(
    email: "e41222905@student.polije.ac.id",
    orderCode: "PasarAja-1752b01d-439f-4d8e-aca4-1067746aa941",
  );

  if (dataTrx is DataSuccess) {
    TransactionHistoryModel order = dataTrx.data as TransactionHistoryModel;
    print('ORDER CODE : ${order.orderCode}');
    print("NAMA TOKO : ${order.shopData?.shopName}");
    print("TANGGAL PESAN : ${order.createdAt}");
    print("DETAIL -->");
    List<TransactionDetailHistoryModel> details =
        order.details as List<TransactionDetailHistoryModel>;
    for (var detail in details) {
      print("\tNAMA PRODUCT : ${detail.product?.productName}");
      print("\tHARGA : ${detail.price}");
      print("\tRATING : ${detail.product?.rating}");
      print("\tTOTAL REVIEW : ${detail.product?.totalReview}");
      // print("\tQUANTITY : ${detail.quantity}");
      // print("\tTOTAL PROMO : ${detail.promoPrice}");
      print("\tTOTAL HARGA : ${detail.totalPrice}");
      print('\t-');
    }
  }
  if (dataTrx is DataFailed) {
    print('Data failed : ${dataTrx.error?.error}');
  }
}
