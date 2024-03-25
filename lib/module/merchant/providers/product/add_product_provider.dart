import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';

class AddProductProvider extends ChangeNotifier {
  // controller, services
  final _controller = ProductController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();
  TextEditingController unitCont = TextEditingController();
  TextEditingController sellingCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();

  ProviderState state = const OnInitState();

  // button state status
  int _buttonState = 0;
  int get buttonState => _buttonState;
  set buttonState(int n) {
    _buttonState = n;
    notifyListeners();
  }

  // error message
  Object _message = '';
  Object get message => _message;
  set message(Object m) {
    _message = m;
    notifyListeners();
  }

  Future<void> addProduct({
    required int idShop,
    required int idCategory,
    required String productName,
    required String description,
    required String unit,
    required int sellingUnit,
    required File photo,
    required int price,
  }) async {
    try {
      state = const OnLoadingState();
      notifyListeners();

      // get id shop from preferences
      int idShop = 1;

      // call controller
      final dataState = await _controller.addProduct(
        idShop: idShop,
        idCategory: idCategory,
        productName: productName,
        description: description,
        unit: unit,
        sellingUnit: sellingUnit,
        photo: photo,
        price: price,
      );

      // produk berhasil disimpan
      if (dataState is DataSuccess) {
        //
      }

      // produk gagal disimpan
      if (dataState is DataFailed) {
        message = dataState.error!.error.toString();
        PasarAjaUtils.triggerVibration();
        PasarAjaMessage.showSnackbarError(message.toString());
      }

      notifyListeners();
    } catch (ex) {
      state = const OnFailureState();
      message = ex.toString();
    }
  }
}
