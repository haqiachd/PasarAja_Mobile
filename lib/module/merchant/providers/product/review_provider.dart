import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/review_model.dart';

class ReviewProvider extends ChangeNotifier {
  // controller
  final _prodController = ProductController();

  // state
  ProviderState state = const OnInitState();

  // best selling
  List<ReviewModel> _reviews = [];
  List<ReviewModel> get reviews => _reviews;

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop from preferences
      final int idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _prodController.reviewPage(
        idShop: idShop,
      );

      // response is successful
      if (dataState is DataSuccess) {
        _reviews = dataState.data as List<ReviewModel>;
        state = const OnSuccessState();
      }

      // response if failure
      if (dataState is DataFailed) {
        state = OnFailureState(dioException: dataState.error);
      }

      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}
