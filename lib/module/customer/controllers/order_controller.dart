import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';

class OrderController {
  final Dio _dio = Dio();
  final String _authUrl = "${PasarAjaConstant.baseUrl}/utrx";

  Future<DataState<List<TransactionHistoryModel>>> _listOfTrx({
    required String email,
    required String type,
  }) async {
    try {
      // call api
      final response = await _dio.get(
        '$_authUrl/list',
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

  Future<DataState<List<TransactionHistoryModel>>> submitted({
    required String email,
  }) async {
    return await _listOfTrx(email: email, type: "Submitted");
  }

  Future<DataState<List<TransactionHistoryModel>>> finished({
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

}

void main() async{
  OrderController _controller = OrderController();

  final dataState = await _controller.tabCancelByMerchant(email: "e41222905@student.polije.ac.id");

  if(dataState is DataSuccess){
    List<TransactionHistoryModel> orders = dataState.data as List<TransactionHistoryModel>;

    for(var order in orders){
      print('ORDER CODE : ${order.orderCode}');
      print("NAMA TOKO : ${order.shopData?.shopName}");
      print("TANGGAL PESAN : ${order.createdAt}");
      print("DETAIL -->");
      List<TransactionDetailHistoryModel> details = order.details as List<TransactionDetailHistoryModel>;
      for(var detail in details){
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

  if(dataState is DataFailed){
    print('ERROR : ${dataState.error?.error}');
  }
}
