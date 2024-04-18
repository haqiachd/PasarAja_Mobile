import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/complain_model.dart';

class ComplainProvider extends ChangeNotifier {
  // controller
  final _prodController = ProductController();

  // state
  ProviderState state = const OnInitState();

  // complains data
  List<ComplainModel> _complains = [];
  List<ComplainModel> get complains => _complains;

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop from preferences
      final int idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _prodController.complainPage(
        idShop: idShop,
      );

      // response is successful
      if (dataState is DataSuccess) {
        _complains = dataState.data as List<ComplainModel>;
        state = const OnSuccessState();
      }

      // response if failure
      if (dataState is DataFailed) {
        state = OnFailureState(dioException: dataState.error);
      }

      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}
