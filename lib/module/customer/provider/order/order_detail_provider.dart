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
import 'package:pasaraja_mobile/module/customer/provider/order/order_submitted_provider.dart';

class CustomerOrderDetailProvider extends ChangeNotifier {
  // controller
  final _controller = OrderController();

  // state
  ProviderState state = const OnInitState();

  // data
  TransactionHistoryModel _order = const TransactionHistoryModel();

  TransactionHistoryModel get order => _order;

  set orders(TransactionHistoryModel o) {
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

      // email
      final email = await PasarAjaUserService.getEmailLogged();

      // get data
      final dataState = await _controller.dataTrx(
        email: email,
        orderCode: orderCode,
      );

      // // jika data didapatkan
      if (dataState is DataSuccess) {
        _order = dataState.data as TransactionHistoryModel;
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

  Future<void> onButtonTakingPressed({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      final confirm = await PasarAjaMessage.showConfirmation(
        'Apakah Anda ingin pergi ke pasar sekarang untuk mengambil pesanan ini?',
        barrierDismissible: true,
      );

      if (!confirm) {
        return;
      }

      PasarAjaMessage.showLoading();

      final dataState = await _controller.inTakingTrx(
        idShop: idShop,
        orderCode: orderCode,
      );

      // jika response berhasil
      if (dataState is DataSuccess) {
        DMethod.log('asu');
        Get.back();
        await PasarAjaMessage.showInformation('Pesanan Berhasil Diupdate');
        Get.back();
      }

      // jika response gagal
      if (dataState is DataFailed) {
        Get.back();
        PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }

      notifyListeners();
    } catch (ex) {
      Fluttertoast.showToast(msg: "Error : ${ex.toString()}");
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
        Get.back();
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

  Future<void> deleteComplain({
    required String orderCode,
    required int idTrx,
    required int idComplain,
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda yakin ingin menghapus komplain?",
        actionYes: 'Iya',
        actionCancel: 'Batal',
        barrierDismissible: true
      );

      if (!confirm) {
        return;
      }

      PasarAjaMessage.showLoading();

      final compTrx = await _controller.deleteComplain(
        idTrx: idTrx,
        idComplain: idComplain,
        idShop: idShop,
        idProduct: idProduct,
      );

      Get.back();

      if (compTrx is DataSuccess) {
        await PasarAjaMessage.showInformation('Komplain Berhasil Dihapus');
        await fetchData(orderCode: orderCode);
      }

      if (compTrx is DataFailed) {
        PasarAjaMessage.showSnackbarWarning(
          compTrx.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      DMethod.log('error : $ex');
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }

  Future<void> deleteReview({
    required String orderCode,
    required int idTrx,
    required int idReview,
    required int idShop,
    required int idProduct,
  }) async {
    try {
      final confirm = await PasarAjaMessage.showConfirmation(
          "Apakah Anda yakin ingin menghapus ulasan?",
          actionYes: 'Iya',
          actionCancel: 'Batal',
          barrierDismissible: true
      );

      if (!confirm) {
        return;
      }

      PasarAjaMessage.showLoading();

      final compTrx = await _controller.deleteReview(
        idTrx: idTrx,
        idReview: idReview,
        idShop: idShop,
        idProduct: idProduct,
      );

      Get.back();

      if (compTrx is DataSuccess) {
        await PasarAjaMessage.showInformation('Komplain Berhasil Dihapus');
        await fetchData(orderCode: orderCode);
      }

      if (compTrx is DataFailed) {
        PasarAjaMessage.showSnackbarWarning(
          compTrx.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      DMethod.log('error : $ex');
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }
}
