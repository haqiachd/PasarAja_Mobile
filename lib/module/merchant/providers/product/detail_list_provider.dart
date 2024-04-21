import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/complain_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_histories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/review_model.dart';

class DetailListProvider extends ChangeNotifier {
  // state & controller
  ProviderState state = const OnInitState();
  final _controller = ProductController();

  // ulasan data
  List<ReviewModel> _reviews = [];
  List<ReviewModel> get reviews => _reviews;
  // complain data
  List<ComplainModel> _complains = [];
  List<ComplainModel> get complains => _complains;
  // history data
  List<ProductHistoriesModel> _history = [];
  List<ProductHistoriesModel> get history => _history;

  Future<void> fetchDataReview({required int idProduct}) async {
    try {
      //
      state = const OnLoadingState();
      notifyListeners();

      // get id shop from preferences
      final int idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.detailListReviewPage(
        idShop: idShop,
        idProd: idProduct,
      );

      if (dataState is DataSuccess) {
        _reviews = dataState.data as List<ReviewModel>;
        state = const OnSuccessState();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          message: dataState.error?.error.toString(),
          dioException: dataState.error,
        );
      }
      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> fetchDataComplain({required int idProduct}) async {
    try {
      //
      state = const OnLoadingState();
      notifyListeners();

      final idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.detailListComplainPage(
        idShop: idShop,
        idProd: idProduct,
      );

      if (dataState is DataSuccess) {
        _complains = dataState.data as List<ComplainModel>;
        state = const OnSuccessState();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          message: dataState.error?.error.toString(),
          dioException: dataState.error,
        );
      }
      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> fetchDataHistory({required int idProduct}) async {
    try {
      //
      state = const OnLoadingState();
      notifyListeners();

      final idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.detailListHistoryPage(
        idShop: idShop,
        idProd: idProduct,
      );

      if (dataState is DataSuccess) {
        _history = dataState.data as List<ProductHistoriesModel>;
        state = const OnSuccessState();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          message: dataState.error?.error.toString(),
          dioException: dataState.error,
        );
      }
      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}
