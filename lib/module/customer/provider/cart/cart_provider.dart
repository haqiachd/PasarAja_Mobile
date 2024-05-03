import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/controllers/cart_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final _cartController = CartController();
  ProviderState state = const OnInitState();

  List<CartModel> carts = [];

  Future<void> fetchData() async {
    try {
      state = const OnLoadingState();
      notifyListeners();

      final dataState = await _cartController.fetchListCart(idUser: 3);

      if (dataState is DataSuccess) {
        carts = dataState.data as List<CartModel>;
        state = const OnSuccessState();
        notifyListeners();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(dioException: dataState.error);
        notifyListeners();
      }
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}
