import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_cancel_page.dart';

class CustomerOrderRequestProvider extends ChangeNotifier {
  // controller
  final _controller = OrderController();

  // state
  ProviderState state = const OnInitState();

  // data
  List<TransactionHistoryModel> _orders = [];

  List<TransactionHistoryModel> get orders => _orders;

  set orders(List<TransactionHistoryModel> o) {
    _orders = o;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      // cek apakah data sudah diload atau tidak
      if (_orders.isNotEmpty) {
        DMethod.log("Load From Data (Request)");
        state = const OnSuccessState();
        notifyListeners();
        return;
      }
      DMethod.log("Load From API (Request)");

      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get email
      final email = await PasarAjaUserService.getEmailLogged();

      DMethod.log('email : $email');

      // get data
      final dataState = await _controller.tabRequest(
        email: email,
      );

      // jika data didapatkan
      if (dataState is DataSuccess) {
        _orders = dataState.data as List<TransactionHistoryModel>;
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

  Future<void> onButtonCancelPressed({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      Get.to(
        OrderCancelPage(idShop: idShop, orderCode: orderCode),
        transition: Transition.cupertino,
        duration: PasarAjaConstant.transitionDuration,
      );
    } catch (ex) {
      //
    }
  }

  void onRefresh() {
    DMethod.log("OnRefresh (Request)");
    _orders = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}
