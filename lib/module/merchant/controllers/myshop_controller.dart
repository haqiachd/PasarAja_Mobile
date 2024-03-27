// ignore_for_file: unused_field

import 'package:dio/dio.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';

class MyShopController {
  final Dio _dio = Dio();
  final String _routeUrl = '${PasarAjaConstant.baseUrl}/route';
}
