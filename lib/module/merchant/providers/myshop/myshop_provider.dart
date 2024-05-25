import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/myshop_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/order/shop_data_model.dart';

class MyShopProvider extends ChangeNotifier {
  ProviderState state = const OnInitState();

  final _controller = MyShopController();

  String _photoProfile = '';
  String get photoProfile => _photoProfile;
  set photoProfile(String f) {
    _photoProfile = f;
    notifyListeners();
  }

  ShopDataModel _shopData = const ShopDataModel();
  ShopDataModel get shopData => _shopData;

  Future<void> fetchData() async {
    try {
      state = const OnLoadingState();
      notifyListeners();

      _photoProfile =
          await PasarAjaUserService.getUserData(PasarAjaUserService.photo);

      final idShop = await PasarAjaUserService.getShopId();

      final dataState = await _controller.getShopData(idShop: idShop);

      if (dataState is DataSuccess) {
        DMethod.log('on success shop data');
        state = const OnSuccessState();
        _shopData = dataState.data as ShopDataModel;
        notifyListeners();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          dioException: dataState.error,
        );
        notifyListeners();
      }

    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}
