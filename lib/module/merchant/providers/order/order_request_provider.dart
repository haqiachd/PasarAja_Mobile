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
import 'package:pasaraja_mobile/module/merchant/views/order/order_cancel_page.dart';

class OrderRequestProvider extends ChangeNotifier {
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
        DMethod.log("Load From Data (Request)");
        state = const OnSuccessState();
        notifyListeners();
        return;
      }
      DMethod.log("Load From API (Request)");

      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // get data
      final dataState = await _controller.tabRequest(
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

  Future<void> onButtonConfirmPressed({
    required String orderCode,
    required String fullName,
  }) async {
    try {
      // show confirmation dialog
      final confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda Yakin Ingin Mengkonfirmasi Pesanan $orderCode dari $fullName",
      );

      if (!confirm) {
        return;
      }

      // show loading
      PasarAjaMessage.showLoading();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.confirmTrx(
        idShop: idShop,
        orderCode: orderCode,
      );

      // close loading
      Get.back();

      // jika pesanan berhasil dikonfirmasi
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Pesanan Berhasil Dikonfirmasi");

        // reset list
        _orders = [];

        // mengambil ulang data pesanan
        await fetchData();
      }

      // jika pesanan gagal dikonfirmasi
      if (dataState is DataFailed) {
        PasarAjaMessage.showWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      PasarAjaMessage.showWarning(ex.toString());
    }
  }

  Future<void> onButtonRejectPressed({
    required String orderCode,
  }) async {
    try {
      Get.to(
        OrderCancelPage(orderCode: orderCode),
        transition: Transition.cupertino,
        duration: PasarAjaConstant.transitionDuration,
      );
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
    }
  }

  void onRefresh() {
    DMethod.log("OnRefresh (Request)");
    _orders = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}
