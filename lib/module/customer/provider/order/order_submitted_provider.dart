import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/order/order_submitted_provider.dart';

class CustomerOrderSubmittedProvider extends ChangeNotifier {
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
        DMethod.log("Load From Data (Submitted)");
        state = const OnSuccessState();
        notifyListeners();
        return;
      }
      DMethod.log("Load From API (Submitted)");

      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get email
      final email = await PasarAjaUserService.getEmailLogged();

      // get data
      final dataState = await _controller.tabSubmitted(
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

  Future<void> onButtonFinishedPressed({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      final confirm = await PasarAjaMessage.showConfirmation(
        'Apakah Anda ingin menyelesaikan pesanan? \nPastikan produk yang Anda terima dalam kondisi baik',
        barrierDismissible: true,
      );

      if (!confirm) {
        return;
      }

      PasarAjaMessage.showLoading();

      final dataState = await _controller.finishTrx(
        idShop: idShop,
        orderCode: orderCode,
      );

      Get.back();
      // jika response berhasil
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation('Pesanan Berhasil Diselesaikan');
        _orders = [];

        fetchData();
      }

      // jika response gagal
      if (dataState is DataFailed) {
        PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }

      notifyListeners();
    } catch (ex) {
      Fluttertoast.showToast(msg: "Error : ${ex.toString()}");
    }
  }

  static Future<void> refreshList() async {
    await OrderSubmittedProvider().fetchData();
  }

  void onRefresh() {
    DMethod.log("OnRefresh (Submitted)");
    _orders = [];
    state = const OnLoadingState();
    notifyListeners();
  }
}
