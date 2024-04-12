import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';

class OrderInTakingProvider extends ChangeNotifier {
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
        DMethod.log("Load From Data (InTaking)");
        state = const OnSuccessState();
        notifyListeners();
        return;
      }
      DMethod.log("Load From API (InTaking)");

      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // get data
      final dataState = await _controller.tabInTaking(
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

  Future<void> onButtonSubmittedPressed({
    required String orderCode,
    required String fullName,
    required String orderId,
  }) async {
    try {
      // show serahkan dialog
      final confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda Yakin Ingin Menyerahkan Pesanan $orderId dari $fullName",
      );

      if (!confirm) {
        return;
      }

      // show loading
      PasarAjaMessage.showLoading();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.submittedTrx(
        idShop: idShop,
        orderCode: orderCode,
      );

      // close loading
      Get.back();

      // jika pesanan berhasil diserahkan
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Pesanan Berhasil Diserahkan");

        // reset list
        _orders = [];

        // mengambil ulang data pesanan
        await fetchData();
      }

      // jika pesanan gagal diserahkan
      if (dataState is DataFailed) {
        PasarAjaMessage.showWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      PasarAjaMessage.showWarning(ex.toString());
    }
  }

  void onRefresh() {
    DMethod.log("OnRefresh (InTaking)");
    _orders = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}
