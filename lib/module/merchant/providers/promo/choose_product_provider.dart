import 'package:flutter/cupertino.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class ChooseProductProvider extends ChangeNotifier {
  // controller
  final _controller = ProductController();

  // state
  ProviderState state = const OnInitState();

  // data
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  set product(List<ProductModel> p) {
    _products = p;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.allProducts(
        idShop: idShop,
      );

      // jika data didapatkan
      if(dataState is DataSuccess){
        _products = dataState.data as List<ProductModel>;
        state = const OnSuccessState();
      }

      // jika data gagal didapatkan
      if(dataState is DataFailed){
        state = OnFailureState(dioException: dataState.error);
      }

      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}
