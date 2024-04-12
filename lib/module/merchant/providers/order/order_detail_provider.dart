import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';

class OrderDetailProvider extends ChangeNotifier {
  // controller
  final _controller = OrderController();

  // state
  ProviderState state = const OnInitState();

  // data
  TransactionModel _order = const TransactionModel();
  TransactionModel get order => _order;
  set orders(TransactionModel o) {
    _order = o;
    notifyListeners();
  }

  Future<void> fetchData({
    required String orderCode,
  }) async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // get data
      final dataState = await _controller.dataTrx(
        idShop: idShop,
        orderCode: orderCode,
        shopData: true,
        userData: true,
      );

      // // jika data didapatkan
      if (dataState is DataSuccess) {
        _order = dataState.data as TransactionModel;
        state = const OnSuccessState();
      }

      // // jika data gagal didapatkan
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
        Get.back();
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
}
