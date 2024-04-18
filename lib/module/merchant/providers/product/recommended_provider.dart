import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class RecommendedProvider extends ChangeNotifier {
  // controller
  // ignore: unused_field
  final _prodController = ProductController();

  // state
  ProviderState state = const OnInitState();

  // produk yang direkomendasikan
  List<ProductModel> _recommendeds = [];
  List<ProductModel> get recommendeds => _recommendeds;

  // rekomendasi status
  bool _isRecommended = false;
  bool get isRecommended => _isRecommended;
  set isRecommended(bool value) {
    _isRecommended = value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // get id shop from preferences
      final int idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _prodController.recommendedPage(
        idShop: idShop,
      );

      // response is successful
      if (dataState is DataSuccess) {
        _isRecommended = true;
        _recommendeds = dataState.data as List<ProductModel>;
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

  Future<void> updateRecommended({required int idProduct}) async {
    try {
      Get.back();
      // show loading
      PasarAjaMessage.showLoading();

      final dataState = await _prodController.updateSettingRecommended(
        idShop: 1,
        idProduct: idProduct,
        recommendedStatus: isRecommended,
      );

      if (isRecommended == true) {
        // untuk memastikan bahwa jika produk direkomendasikan maka produk juga harus ditampilkan
        await _prodController.updateSettingVisibility(
          idShop: 1,
          idProduct: idProduct,
          visibilityStatus: true,
        );
      }

      Get.back();

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation(
            "Produk berhasil direkomendasikan");
      }

      if (dataState is DataFailed) {
        await PasarAjaMessage.showInformation(
          "Stok gagal direkomendasikan!\n\nError : ${dataState.error?.error}",
        );
      }
    } catch (ex) {
      // nothing
    }
  }
}
