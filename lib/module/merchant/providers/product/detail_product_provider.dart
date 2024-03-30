import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_detail_page_model.dart';

class DetailProductProvider extends ChangeNotifier {
  // state & controller
  ProviderState state = const OnInitState();
  final _controller = ProductController();

  // data
  ProductDetailModel _detailProd = ProductDetailModel();
  ProductDetailModel get detailProd => _detailProd;

  Future<void> fetchData({required int idProduct}) async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // call controller
      final dataState = await _controller.detailProductPage(
        idShop: 1,
        idProd: idProduct,
      );

      if (dataState is DataSuccess) {
        _detailProd = dataState.data as ProductDetailModel;
        state = const OnSuccessState();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          message: dataState.error?.message,
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
