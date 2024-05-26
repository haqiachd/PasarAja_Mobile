import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/controllers/shopping_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/product_categories_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class CustomerProductProvider extends ChangeNotifier{
  final _controller = ShoppingController();

  ProviderState state = const OnInitState();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<ProductCategoryModel> _categories = [];
  List<ProductCategoryModel> get categories => _categories;

  TextEditingController cariProd = TextEditingController();

  List<ProductModel> _productsFil = [];
  List<ProductModel> get productsFil => _productsFil;

  void cari(){
    _productsFil = products
        .where((element) => element.productName?.toLowerCase().contains(cariProd.text.toLowerCase()) ?? false)
        .toList();
    notifyListeners();
  }

  bool _isLoaded = false;

  Future<void> fetchData() async {
    try {

      if (_isLoaded){
        DMethod.log("Load From Data (Product)");
        state = const OnSuccessState();
        notifyListeners();
        return;
      }
      DMethod.log("Load From API (Product)");

      state = const OnLoadingState();
      notifyListeners();

      // get category data
      var dataStateCtg = await _controller.fetchCategoriesData();
      if(dataStateCtg is DataSuccess){
        _categories = dataStateCtg.data as List<ProductCategoryModel>;
      }else{
        _categories = [];
      }
      notifyListeners();

      var dataState = await _controller.fetchProdData();

      if (dataState is DataSuccess) {
        _isLoaded = true;
        _products = dataState.data as List<ProductModel>;
        state = const OnSuccessState();
        notifyListeners();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          message: dataState.error?.error.toString() ??
              PasarAjaConstant.unknownError,
        );
        notifyListeners();
      }
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  void onRefresh() {
    _isLoaded = false;
    DMethod.log("OnRefresh (List Product)");
    _categories = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}