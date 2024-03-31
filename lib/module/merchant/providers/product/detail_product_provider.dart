import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_detail_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_settings_model.dart';

class DetailProductProvider extends ChangeNotifier {
  // state & controller
  ProviderState state = const OnInitState();
  final _controller = ProductController();

  // data
  ProductDetailModel _detailProd = ProductDetailModel();
  ProductDetailModel get detailProd => _detailProd;

  // setting data
  bool isAvailable = false;
  bool isRecommended = false;
  bool isShown = false;

  // temp setting data
  // stok
  bool _isAvailableTemp = false;
  bool get isAvailableTemp => _isAvailableTemp;
  set isAvailableTemp(bool value) {
    _isAvailableTemp = value;
    notifyListeners();
  }

  // rekomendasi
  bool _isRecommendedTemp = false;
  bool get isRecommendedTemp => _isRecommendedTemp;
  set isRecommendedTemp(bool value) {
    _isRecommendedTemp = value;
    if (_isRecommendedTemp) {
      _isShownTemp = true;
    }
    notifyListeners();
  }

  // visibilty
  bool _isShownTemp = false;
  bool get isShownTemp => _isShownTemp;
  set isShownTemp(bool value) {
    _isShownTemp = value;
    if (!_isShownTemp) {
      _isRecommendedTemp = false;
    }
    notifyListeners();
  }

  Future<void> fetchData({required int idProduct}) async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // call controller
      final dataState = await _controller.detailProductPage(
        idShop: 1,
        idProd: idProduct,
      );

      if (dataState is DataSuccess) {
        _detailProd = dataState.data as ProductDetailModel;

        // get setting data
        final settings = _detailProd.settings as ProductSettingsModel;
        isAvailable = settings.isAvailable ?? false;
        isRecommended = settings.isRecommended ?? false;
        isShown = settings.isShown ?? false;
        // temp data
        _isAvailableTemp = isAvailable;
        _isRecommendedTemp = isRecommended;
        _isShownTemp = isShown;

        state = const OnSuccessState();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          message: dataState.error?.message,
          dioException: dataState.error,
        );
      }

      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> onPressedDelete({required int idProduct}) async {
    try {
      // show confirm dialog
      final confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda yakin ingin menghapus produk ini?\n\nNote : Produk akan terhapus secara permanen!",
        barrierDismissible: true,
      );

      if (confirm) {
        PasarAjaMessage.showLoading();

        // call controller
        final dataState = await _controller.deleteProduct(
          idShop: 1,
          idProduct: idProduct,
        );

        // close loading
        Get.back();

        // jika produk berhasil dihapus
        if (dataState is DataSuccess) {
          await PasarAjaMessage.showInformation("Produk berhasil dihapus");
          Get.back();
        }

        // jika produk gagal dihapus
        if (dataState is DataFailed) {
          Fluttertoast.showToast(msg: dataState.error!.error.toString());
        }

        Get.back();
      }
    } catch (ex) {
      PasarAjaUtils.triggerVibration();
      Fluttertoast.showToast(msg: ex.toString());
    }
  }

  Future<void> updateSettings({required idProduct}) async {
    try {
      Get.back();

      PasarAjaMessage.showLoading();

      final updateStok = await _controller.updateSettingStok(
        idShop: 1,
        idProduct: idProduct,
        stokStatus: isAvailableTemp,
      );

      if (updateStok is DataSuccess) {
        isAvailable = isAvailableTemp;
        DMethod.log('update stok berhasil');
      }
      if (updateStok is DataFailed) {
        DMethod.log(
            'update stok gagal berhasil --> ${updateStok.error!.error}');
      }

      final updateRecommended = await _controller.updateSettingRecommended(
        idShop: 1,
        idProduct: idProduct,
        recommendedStatus: isRecommendedTemp,
      );

      if (updateRecommended is DataSuccess) {
        isRecommended = isRecommendedTemp;
        DMethod.log('update rekomendasi berhasil');
      }
      if (updateRecommended is DataFailed) {
        DMethod.log(
            'update rekomendasi gagal berhasil --> ${updateRecommended.error!.error}');
      }

      final updateShown = await _controller.updateSettingVisibility(
        idShop: 1,
        idProduct: idProduct,
        visibilityStatus: isShownTemp,
      );

      if (updateShown is DataSuccess) {
        isShown = isShownTemp;
        DMethod.log('update visibility berhasil');
      }
      if (updateShown is DataFailed) {
        DMethod.log(
            'update visibilty gagal berhasil --> ${updateShown.error!.error}');
      }

      Get.back();

      if (updateStok is DataSuccess &&
          updateRecommended is DataSuccess &&
          updateShown is DataSuccess) {
        PasarAjaMessage.showInformation("Update berhasil");
      } else {
        PasarAjaMessage.showSnackbarError("Keternagan produk gagal diupdate");
      }

      notifyListeners();
    } catch (ex) {
      PasarAjaUtils.triggerVibration();
      Fluttertoast.showToast(msg: ex.toString());
    }
  }
}
