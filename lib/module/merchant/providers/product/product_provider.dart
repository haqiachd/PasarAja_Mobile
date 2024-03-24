import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/highest_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_category_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductController _productController = ProductController();

  // state
  ProviderState state = const OnInitState();

  // data product categories
  List<ProductCategoryModel> _categories = [];
  List<ProductCategoryModel> get categories => _categories;

  // data product
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  // data highest rating
  List<HighestModel> _highests = [];
  List<HighestModel> get highest => _highests;

  // data best selling
  List<ProductModel> _sellings = [];
  List<ProductModel> get sellings => _sellings;

  Future<void> fetchData() async {
    try {
      state = const OnLoadingState();
      notifyListeners();

      // call controller
      final dataState = await _productController.productPage(
        idShop: 1,
      );

      if (dataState is DataSuccess) {
        ProductPageModel model = dataState.data as ProductPageModel;
        // get data
        _categories = model.categories ?? [];
        _products = model.products ?? [];
        _highests = model.highest ?? [];
        _sellings = model.sellings ?? [];
        // update state
        state = const OnSuccessState();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(dioException: dataState.error);
      }

      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
    }
  }

  void resetData() {
    state = const OnInitState();
    notifyListeners();
  }
}
