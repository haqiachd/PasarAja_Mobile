import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/choose_categories_model.dart';

class ChooseCategoriesProvider extends ChangeNotifier {
  // state & controller
  ProviderState state = const OnInitState();
  final _controller = ProductController();

  // data kategory
  List<ChooseCategoriesModel> _categories = [];
  List<ChooseCategoriesModel> get categories => _categories;

  Future<void> fetchData() async {
    try {
      // update loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop from preferences
      final int idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.listCategory(
        idShop: idShop,
      );

      if (dataState is DataSuccess) {
        _categories = dataState.data as List<ChooseCategoriesModel>;
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
