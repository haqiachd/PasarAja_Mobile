import 'package:d_method/d_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
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

        List<ProductModel> productsToRemove = [];

        for (var prod in _products) {
          // DMethod.log('promo : ${prod.promo}');
          if (PasarAjaUtils.isSoonAndActivePromo(prod.promo)) {
            productsToRemove.add(prod);
          }
        }

        // Remove the collected products from _products
        _products.removeWhere((prod) => productsToRemove.contains(prod));
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
