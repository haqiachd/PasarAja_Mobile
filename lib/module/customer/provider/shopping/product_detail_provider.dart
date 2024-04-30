import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/controllers/shopping_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/product_detail_model.dart';

class CustomerProductDetailProvider extends ChangeNotifier {
  final _controller = ShoppingController();

  ProviderState state = const OnInitState();
  ProductDetailModel _productDetail = const ProductDetailModel();
  ProductDetailModel get productDetail => _productDetail;

  Future<void> fetchData({required int idShop, required int idProduct}) async {
    try {
      state = const OnLoadingState();
      notifyListeners();

      final dataState = await _controller.fetchProdDetail(
        idShop: idShop,
        idProduct: idProduct,
      );

      if (dataState is DataSuccess) {
        _productDetail = dataState.data as ProductDetailModel;
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

}
