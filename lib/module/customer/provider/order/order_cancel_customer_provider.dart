import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';

class CustomerOrderCancelCustomerProvider extends ChangeNotifier{
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
        DMethod.log("Load From Data (Cancel Customer)");
        state = const OnSuccessState();
        notifyListeners();
        return;
      }
      DMethod.log("Load From API (Cancel Customer)");

      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop
      final email = await PasarAjaUserService.getEmailLogged();

      // get data
      final dataState = await _controller.tabCancelByCustomer(
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
}