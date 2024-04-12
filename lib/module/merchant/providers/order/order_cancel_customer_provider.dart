import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';

class OrderCancelCustomerProvider extends ChangeNotifier {
  // controller
  final _controller = OrderController();

  // state
  ProviderState state = const OnInitState();

  // data
  List<TransactionModel> _orders = [];
  List<TransactionModel> get orders => _orders;
  set orders(List<TransactionModel> o) {
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
      final idShop = await PasarAjaUserService.getShopId();

      // get data
      final dataState = await _controller.tabCancelByCustomer(
        idShop: idShop,
      );

      // jika data didapatkan
      if (dataState is DataSuccess) {
        _orders = dataState.data as List<TransactionModel>;
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
    required String reason,
    required String message,
  }) async {
    try {
      // show loading
      PasarAjaMessage.showLoading();

      // call controller
      final dataState = await _controller.cancelByCustomerTrx(
        idShop: idShop,
        orderCode: orderCode,
        reason: reason,
        message: message,
      );

      // close loading
      Get.back();

      // jika pesanan berhasil dibatalakn
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Pesanan Berhasil Dibatalkan");
      }

      // jika pesanan gagal dibatalkan
      if (dataState is DataFailed) {
        Fluttertoast.showToast(
          msg: dataState.error?.error.toString() ??
              PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
    }
  }

  void onRefresh() {
    DMethod.log("OnRefresh (Cancel by Customer)");
    _orders = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}
