import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class HiddenProvider extends ChangeNotifier {
  // controller
  // ignore: unused_field
  final _prodController = ProductController();

  // state
  ProviderState state = const OnInitState();

  // produk yang disembunyikan
  List<ProductModel> _hiddens = [];
  List<ProductModel> get hiddens => _hiddens;

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // call controller
      final dataState = await _prodController.hiddenPage(
        idShop: 1,
      );

      // response is successful
      if (dataState is DataSuccess) {
        _hiddens = dataState.data as List<ProductModel>;
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
