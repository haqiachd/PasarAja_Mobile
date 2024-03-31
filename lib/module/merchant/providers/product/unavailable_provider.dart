import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class UnavailableProvider extends ChangeNotifier {
  // controller
  // ignore: unused_field
  final _prodController = ProductController();

  // state
  ProviderState state = const OnInitState();

  // produk yang stok nya habis
  List<ProductModel> _unavailables = [];
  List<ProductModel> get unavailables => _unavailables;

  // stok status
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;
  set isAvailable(bool value) {
    _isAvailable = value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // call controller
      final dataState = await _prodController.unavailablePage(
        idShop: 1,
      );

      // response is successful
      if (dataState is DataSuccess) {
        _isAvailable = false;
        _unavailables = dataState.data as List<ProductModel>;
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

  Future<void> updateAvailable({required int idProduct}) async {
    try {
      Get.back();
      // show loading
      PasarAjaMessage.showLoading();

      final dataState = await _prodController.updateSettingStok(
        idShop: 1,
        idProduct: idProduct,
        stokStatus: isAvailable,
      );

      Get.back();

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Stok berhasil diupdate");
      }

      if (dataState is DataFailed) {
        await PasarAjaMessage.showInformation(
          "Stok gagal diupdate!\n\nError : ${dataState.error?.error}",
        );
      }
    } catch (ex) {
      // nothing
    }
  }
}
