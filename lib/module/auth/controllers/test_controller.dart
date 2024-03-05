import 'dart:convert';
import 'dart:io';

import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/module/auth/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class TestController {
  final Dio _dio = Dio();

  final String signInUrl = '${PasarAjaConstant.baseUrl}/auth/signin';

  Future<DataState> login({
    required String email,
  }) async {
    // endpoint
    final apiUrl = Uri.parse("$signInUrl/google");

    // request
    var response = await http.post(
      apiUrl,
      body: {
        "email": email,
      },
    );

    // get payload
    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      // jika response success
      return DataSuccess(UserModel.fromJson(body['data']));
    } else {
      // jika response failed
      return DataFailed(
        DioError(
          requestOptions: RequestOptions(path: ''),
          error: body['message'],
        ),
      );
    }
  }

  Future<DataState> loginDio({
    required String email,
  }) async {
    try {
      // kirim request login google
      final response = await _dio.post(
        "$signInUrl/google",
        data: {
          "email": email,
        },
        options: Options(
          validateStatus: (status) {
            // Validasi status code
            return status == HttpStatus.ok || status == HttpStatus.badRequest;
          },
        ),
      );

      // medapatkan payload dari response
      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        // jika success maka akan mengembalikan data dari reponse
        return DataSuccess(UserModel.fromJson(payload['data']));
      } else {
        // jika gagal maka akan mengembalikan pesan error
        return DataFailed(
          DioError(
            requestOptions: response.requestOptions,
            response: response,
            type: DioErrorType.response,
            error: payload['message'],
          ),
        );
      }
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }

}

void main(List<String> args) async {
  TestController testController = TestController();
  // final data = await testController.login(email: 'hakiahmad756@gmail.com');

  // if (data is DataSuccess) {
  //   var model = data.data as UserModel;
  //   print('nama : ${model.fullName}');
  // }

  // if (data is DataFailed) {
  //   print(data.error);
  // }

  final dataDio = await testController.loginDio(email: 'hakiahmad756@gmails.com');

  if (dataDio is DataSuccess) {
    var model = dataDio.data as UserModel;
    print('nama : ${model.fullName}');
  }

  if (dataDio is DataFailed) {
    print(dataDio.error!.error);
  }
}
