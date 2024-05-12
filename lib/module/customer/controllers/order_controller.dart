import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/customer/models/create_transaction_model.dart';
import 'package:pasaraja_mobile/module/customer/models/review_model.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';

class OrderController {
  final Dio _dio = Dio();
  final String _apiUserTrx = "${PasarAjaConstant.baseUrl}/utrx";
  final String _apiShopTrx = "${PasarAjaConstant.baseUrl}/trx";
  final String _orderComp = "${PasarAjaConstant.baseUrl}/prod/comp";
  final String _orderRvw = "${PasarAjaConstant.baseUrl}/prod/rvw";

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

      print('payload : ${payload['data']}');

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

  Future<DataState<bool>> createTrx({
    required CreateTransactionModel createTransaction,
  }) async {
    try {
      // send request
      final response = await _dio.post(
        '$_apiShopTrx/crtrx',
        data: jsonEncode(createTransaction.toJson()),
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

  Future<DataState<bool>> writeComplain({
    required String orderCode,
    required int idUser,
    required int idShop,
    required int idProduct,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        "$_orderComp/add",
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
                status == HttpStatus.notFound ||
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

  Future<DataState<bool>> updateComplain({
    required int idTrx,
    required int idComplain,
    required int idShop,
    required int idProduct,
    required String reason,
  }) async {
    try {
      final response = await _dio.put(
        "$_orderComp/update",
        data: {
          "id_trx": idTrx,
          "id_complain": idComplain,
          "id_shop": idShop,
          "id_product": idProduct,
          "reason": reason,
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
    required int idTrx,
    required int idComplain,
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final response = await _dio.delete(
        "$_orderComp/delete",
        data: {
          "id_trx": idTrx,
          "id_complain": idComplain,
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

  Future<DataState<bool>> writeReview({
    required String orderCode,
    required int idUser,
    required int idShop,
    required int idProduct,
    required String star,
    required String comment,
  }) async {
    try {
      final response = await _dio.post(
        "$_orderRvw/add",
        data: {
          "order_code": orderCode,
          "id_user": idUser,
          "id_shop": idShop,
          "id_product": idProduct,
          "star" : star,
          "comment": comment,
        },
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.created ||
                status == HttpStatus.notFound ||
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

  Future<DataState<bool>> updateReview({
    required int idTrx,
    required int idReview,
    required int idShop,
    required int idProduct,
    required String star,
    required String comment,
  }) async {
    try {
      final response = await _dio.put(
        "$_orderRvw/update",
        data: {
          "id_trx": idTrx,
          "id_review": idReview,
          "id_shop": idShop,
          "star" : star,
          "id_product": idProduct,
          "comment": comment,
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
    required int idTrx,
    required int idReview,
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final response = await _dio.delete(
        "$_orderRvw/delete",
        data: {
          "id_trx": idTrx,
          "id_review": idReview,
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
  OrderController _controller = OrderController();

  final dataState = await _controller.tabRequest(
      email: "pkmki2023.thegsteam@gmail.com");

  if (dataState is DataSuccess) {
    print('DATA SUCCESS');
    List<TransactionHistoryModel> orders =
        dataState.data as List<TransactionHistoryModel>;

    for (var order in orders) {
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
      print('-------------------');
    }
  }

  if (dataState is DataFailed) {
    print('ERROR : ${dataState.error?.error}');
  }

  // final dataTrx = await _controller.dataTrx(
  //   email: "pkmki2023.thegsteam@gmail.com",
  //   orderCode: "PasarAja-9156976d-b8fd-4dfe-80c2-339fbdb5030a",
  // );
  //
  // if (dataTrx is DataSuccess) {
  //   TransactionHistoryModel order = dataTrx.data as TransactionHistoryModel;
  //   print('ORDER CODE : ${order.orderCode}');
  //   print("NAMA TOKO : ${order.shopData?.shopName}");
  //   print("TANGGAL PESAN : ${order.createdAt}");
  //   print("DETAIL -->");
  //   List<TransactionDetailHistoryModel> details =
  //       order.details as List<TransactionDetailHistoryModel>;
  //   for (var detail in details) {
  //     print("\tNAMA PRODUCT : ${detail.product?.productName}");
  //     print("\tHARGA : ${detail.price}");
  //     print("\tRATING : ${detail.product?.rating}");
  //     print("\tTOTAL REVIEW : ${detail.product?.totalReview}");
  //     // print("\tQUANTITY : ${detail.quantity}");
  //     // print("\tTOTAL PROMO : ${detail.promoPrice}");
  //     print("\tTOTAL HARGA : ${detail.totalPrice}");
  //     print('\t-');
  //     var rvw = detail.review as ReviewModel;
  //     print(rvw.comment);
  //     print("\tCOMMENT : ${rvw.comment}");
  //     print('\t-');
  //   }
  // }
  // if (dataTrx is DataFailed) {
  //   print('Data failed : ${dataTrx.error?.error}');
  // }

  // final compTrx = await _controller.writeComplain(
  //   orderCode: 'PasarAja-be4e36ef-03ea-456f-aa55-f8dae76155b1',
  //   idUser: 25,
  //   idShop: 1,
  //   idProduct: 3,
  //   reason: 'lorem ipsum dolor sit amet',
  // );
  //
  // if (compTrx is DataSuccess) {
  //   print('Comp Success');
  // }
  //
  // if (compTrx is DataFailed) {
  //   print('Comp failed : ${compTrx.error?.error}');
  // }

  // final compTrx = await _controller.updateComplain(
  //   idTrx: 86,
  //   idComplain: 14,
  //   idShop: 1,
  //   idProduct: 3,
  //   reason: 'lorem ipsum',
  // );
  //
  // if (compTrx is DataSuccess) {
  //   print('Comp Success');
  // }
  //
  // if (compTrx is DataFailed) {
  //   print('Comp failed : ${compTrx.error?.error}');
  // }
  //
  // final compTrx = await _controller.deleteComplain(
  //   idTrx: 86,
  //   idComplain: 14,
  //   idShop: 1,
  //   idProduct: 3,
  // );
  //
  // if (compTrx is DataSuccess) {
  //   print('Comp Success');
  // }
  //
  // if (compTrx is DataFailed) {
  //   print('Comp failed : ${compTrx.error?.error}');
  // }

  final rvwTrx = await _controller.writeReview(
    orderCode: 'PasarAja-be4e36ef-03ea-456f-aa55-f8dae76155b1',
    idUser: 25,
    idShop: 1,
    idProduct: 3,
    star: '5',
    comment: 'lorem ipsum dolor sit amet',
  );

  if (rvwTrx is DataSuccess) {
    print('Comp Success');
  }

  if (rvwTrx is DataFailed) {
    print('Comp failed : ${rvwTrx.error?.error}');
  }

  // final rvwTrx = await _controller.updateReview(
  //   idTrx: 86,
  //   idReview: 15,
  //   idShop: 1,
  //   idProduct: 3,
  //   star: '1',
  //   comment: 'ga enak',
  // );
  //
  // if (rvwTrx is DataSuccess) {
  //   print('Comp Success');
  // }
  //
  // if (rvwTrx is DataFailed) {
  //   print('Comp failed : ${rvwTrx.error?.error}');
  // }

  // final rvwTrx = await _controller.deleteReview(
  //   idTrx: 86,
  //   idReview: 15,
  //   idShop: 1,
  //   idProduct: 3,
  // );
  //
  // if (rvwTrx is DataSuccess) {
  //   print('Comp Success');
  // }
  //
  // if (rvwTrx is DataFailed) {
  //   print('Comp failed : ${rvwTrx.error?.error}');
  // }
}
