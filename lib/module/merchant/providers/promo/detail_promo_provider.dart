import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/promo_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';

class DetailPromoProvider extends ChangeNotifier {
  // controller
  final _controller = PromoController();

  // state
  ProviderState state = const OnInitState();

  // data
  PromoModel _promo = const PromoModel();

  PromoModel get promo => _promo;

  // get data promo
  Future<void> fetchData({required int idPromo}) async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // get data
      final dataState = await _controller.detailPromo(
        idShop: idShop,
        idPromo: idPromo,
      );

      if (dataState is DataSuccess) {
        _promo = dataState.data as PromoModel;
        state = const OnSuccessState();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(dioException: dataState.error);
      }

      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> onDeletePressed({
    required int idPromo,
    required String productName,
  }) async {
    try {
      // show konfirmasi hapus
      final confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda Ingin Menghapus Promo Pada '$productName'",
      );

      if (!confirm) {
        return;
      }

      DMethod.log('id promo : $idPromo');

      PasarAjaMessage.showLoading();

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.deletePromo(
        idShop: idShop,
        idPromo: idPromo,
      );

      // jika data berhasil dihapus
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Promo Berhasil Dihapus");
        Get.back();
        Get.back();
      }

      // jika data gagal dihapus
      if (dataState is DataFailed) {
        await PasarAjaMessage.showWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
        Get.back();
      }
    } catch (ex) {
      Get.back();
      await PasarAjaMessage.showWarning(ex.toString());
    }
  }
}
