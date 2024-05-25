// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';

// import 'package:d_method/d_method.dart';
import 'package:d_method/d_method.dart';
import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/operational_model.dart';

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
        DMethod.log('data failed : ${opr.error!.error}');
      }
    }catch(ex){
      DMethod.log('error : $ex');
    }
    return close;
  }

}

void main() async {
   var close = await new MyShopController().getCloseDays(1);

  for(var c in close){
    print('${c}');
  }
}
