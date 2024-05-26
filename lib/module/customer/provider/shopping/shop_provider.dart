import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/controllers/shopping_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class CustomerShopProvider extends ChangeNotifier {
  final _controller = ShoppingController();

  TextEditingController cariShop = TextEditingController();

  ProviderState state = const OnInitState();
  List<ShopDataModel> _shops = [];
  List<ShopDataModel> get shops => _shops;

  List<ShopDataModel> _shopsFil = [];
  List<ShopDataModel> get shopsFil => _shopsFil;

  void cari(){
    _shopsFil = shops
        .where((element) => element.shopName?.toLowerCase().contains(cariShop.text.toLowerCase()) ?? false)
        .toList();
    notifyListeners();
  }

  set shops(List<ShopDataModel> s) {
    _shops = s;
    notifyListeners();
  }

  bool _isLoaded = false;

  Future<void> fetchData() async {
    try {

      if (_isLoaded){
        DMethod.log("Load From Data (Shop)");
        state = const OnSuccessState();
        notifyListeners();
        return;
      }
      DMethod.log("Load From API (Shop)");

      state = const OnLoadingState();
      notifyListeners();

      final dataState = await _controller.fetchShopData();

      if (dataState is DataSuccess) {
        _isLoaded = true;
        _shops = dataState.data as List<ShopDataModel>;
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
    DMethod.log("OnRefresh (List Shop)");
    _shops = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}
