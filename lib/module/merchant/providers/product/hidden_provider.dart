import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class HiddenProvider extends ChangeNotifier {
  // controller
  // ignore: unused_field
  final _prodController = ProductController();

  // state
  ProviderState state = const OnInitState();

  // produk yang disembunyikan
  List<ProductModel> _hiddens = [];
  List<ProductModel> get hiddens => _hiddens;

  // visibility status
  bool _isShown = false;
  bool get isShown => _isShown;
  set isShown(bool value) {
    _isShown = value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // call controller
      final dataState = await _prodController.hiddenPage(
        idShop: 1,
      );

      // response is successful
      if (dataState is DataSuccess) {
        _isShown = false;
        _hiddens = dataState.data as List<ProductModel>;
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

  Future<void> updateVisibility({required int idProduct}) async {
    try {
      Get.back();
      // show loading
      PasarAjaMessage.showLoading();

      final dataState = await _prodController.updateSettingVisibility(
        idShop: 1,
        idProduct: idProduct,
        visibilityStatus: isShown,
      );

      if (isShown == false) {
        // untuk memastikan bahwa jika produk di sembuyikan maka produk juga tidak direkomendasikan
        await _prodController.updateSettingRecommended(
          idShop: 1,
          idProduct: idProduct,
          recommendedStatus: false,
        );
      }

      Get.back();

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Produk berhasil ditampilkan");
      }

      if (dataState is DataFailed) {
        await PasarAjaMessage.showInformation(
          "Stok gagal ditampilkan!\n\nError : ${dataState.error?.error}",
        );
      }
    } catch (ex) {
      // nothing
    }
  }
}
