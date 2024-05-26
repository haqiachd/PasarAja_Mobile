// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';

// import 'package:d_method/d_method.dart';
// import 'package:d_method/d_method.dart';
import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/operational_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/order/shop_data_model.dart';

class MyShopController {
  final Dio _dio = Dio();
  final String _routeUrl =
      PasarAjaConstant.baseUrl.replaceFirst(RegExp('m\$'), '');

  Future<DataState<bool>> updateOperational({
    required int idShop,
    required OperationalModel operational,
  }) async {
    try {
      // send request
      final response = await _dio.post(
        '${_routeUrl}shop/operational',
        data: {
          "id_shop": idShop,
          "operational": jsonEncode(operational.toJson()),
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

  Future<DataState<OperationalModel>> getOperational({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        '${_routeUrl}shop/getopr',
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
        return DataSuccess(OperationalModel.fromJson(payload['data']));
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

  Future<List<int>> getCloseDays(int idShop) async {
    List<int> close = [1, 2, 3, 4, 5, 6, 7];
    try{
      final opr = await getOperational(idShop: idShop);

      if(opr is DataSuccess){
        var data = opr.data as OperationalModel;

        if(data.senin ?? false){
          close.remove(DateTime.monday);
        }

        if(data.selasa ?? false){
          close.remove(DateTime.tuesday);
        }

        if(data.rabu ?? false){
          close.remove(DateTime.wednesday);
        }

        if(data.kamis ?? false){
          close.remove(DateTime.thursday);
        }

        if(data.jumat ?? false){
          close.remove(DateTime.friday);
        }

        if(data.sabtu ?? false){
          close.remove(DateTime.saturday);
        }

        if(data.minggu ?? false){
          close.remove(DateTime.sunday);
        }

        return close;
      }

      if(opr is DataFailed){
        // DMethod.log('data failed : ${opr.error!.error}');
      }
    }catch(ex){
      // DMethod.log('error : $ex');
    }
    return close;
  }

  Future<DataState<ShopDataModel>> getShopData({
    required int idShop,
  }) async {
    try {
      // send request
      final response = await _dio.get(
        '${_routeUrl}shop/data',
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
      // print(payload);

      // return response
      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ShopDataModel.fromJson(payload['data']));
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

  Future<DataState<bool>> updateShopData({
    required int idShop,
    required String shopName,
    required String phone,
    required String benchmark,
    required String description,
  }) async {
    try {
      // send request
      final response = await _dio.put(
        '${_routeUrl}shop/updatemob',
        queryParameters: {
          "id_shop": idShop,
          'shop_name' : shopName,
          'phone_number' : '62$phone',
          'benchmark' : benchmark,
          'description' : description,
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
      // print(payload);

      // return response
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


  Future<DataState<bool>> updateShopPhoto({
    required int idShop,
    required File photo,
  }) async {
    try {
      // create form
      FormData formData = FormData.fromMap(
        {
          "id_shop": idShop,
          "photo": await MultipartFile.fromFile(photo.path, filename: 'product.png'),
        },
      );

      // call api
      final response = await _dio.post(
        '${_routeUrl}shop/updatemobphoto',
        data: formData,
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
   var kont = MyShopController();

   final dataState = await kont.getShopData(idShop: 1);

   if(dataState is DataSuccess){
     var toko = dataState.data as ShopDataModel;
     print('total rating : ${toko.totalRating}');
   }

   if(dataState is DataFailed){
     print('error : ${dataState.error?.error}');
   }
}
