import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/promo_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';

class PromoSoonProvider extends ChangeNotifier {
  // controller
  final _controller = PromoController();

  // state
  ProviderState state = const OnInitState();

  // list promo
  List<PromoModel> _promos = [];
  List<PromoModel> get promos => _promos;
  set promos(List<PromoModel> p) {
    _promos = p;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      // cek apakah data sudah diload
      if (_promos.isNotEmpty) {
        state = const OnSuccessState();
        notifyListeners();
        DMethod.log('data sudah di load');
        return;
      }

      DMethod.log('meload data');
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get idshop
      final idShop = await PasarAjaUserService.getShopId();

      // fetch data promo
      final dataState = await _controller.fetchSoonPromo(
        idShop: idShop,
      );

      // jika data didapatkan
      if (dataState is DataSuccess) {
        _promos = dataState.data as List<PromoModel>;
        state = const OnSuccessState();
      }

      // jika data gagal didapatkan
      if (dataState is DataFailed) {
        state = OnFailureState(dioException: dataState.error);
      }

      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  void onRefresh() {
    _promos = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}
