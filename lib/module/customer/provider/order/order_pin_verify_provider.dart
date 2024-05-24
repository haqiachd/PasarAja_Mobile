import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/models/create_transaction_model.dart';

class CustomerOrderPinVerifyProvider extends ChangeNotifier {
  final _controller = OrderController();

  int _from = 0;

  int get from => _from;

  set from(int i) {
    _from = i;
    notifyListeners();
  }

  String _selectedDate = '';

  String get selectedDate => _selectedDate;

  CartModel _cartModel = CartModel();

  CartModel get cartModel => _cartModel;

  Future<void> onInit({
    required int from,
    required String selectedDate,
    required CartModel cartModel,
  }) async {
    _from = from;
    _selectedDate = selectedDate;
    _cartModel = cartModel;
    notifyListeners();
  }

  //
  Future<void> onValidatePin({
    required String pin,
  }) async {
    try {
      int idUser = await PasarAjaUserService.getUserId();

      DMethod.log('id user : $idUser');
      DMethod.log('pin : $pin');
      await Future.delayed(const Duration(seconds: 1));

      PasarAjaMessage.showLoading();

      await Future.delayed(const Duration(seconds: 3));

      // validasi data
      final dataState = await _controller.verifyPinTrx(
        idUser: idUser,
        pin: pin,
      );

      Get.back();

      if (dataState is DataSuccess) {
        await onCreateTrx();
      }

      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        await PasarAjaMessage.showSnackbarWarning(
          'PIN Anda Tidak Cocok!',
        );
      }
    } catch (ex) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      await PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }

  Future<void> onCreateTrx() async {
    try {
      // menampilkan loading
      PasarAjaMessage.showLoading();

      // get id user, email & inisialisasi id shop
      final idUser = await PasarAjaUserService.getUserId();
      final emailUser = await PasarAjaUserService.getEmailLogged();
      int idShop = 0;

      // list produk kosong
      final List<ProductTransactionModel> prods = [];

      // mendapatkan data produk yang dibeli
      for (var prod in cartModel.products!) {
        DMethod.log('from : $_from');
        DMethod.log('selected date : $_selectedDate');
        DMethod.log('id prod : ${prod.idProduct}');
        DMethod.log('prod name : ${prod.productData!.productName}');
        DMethod.log('quantity : ${prod.quantity}');
        DMethod.log(
            'promo price : ${PasarAjaUtils.isActivePromo(prod.productData!.promo!) ? (prod.productData!.price! - prod.productData!.promo!.promoPrice!) : 0}');
        DMethod.log('notes : ${prod.notes}');
        DMethod.log('checked : ${prod.checked}');
        DMethod.log('-' * 10);

        if (prod.checked) {
          // menyimpan data prouduk yang dibeli
          var prodTrx = ProductTransactionModel(
            idProduct: prod.idProduct,
            quantity: prod.quantity,
            promoPrice: PasarAjaUtils.isActivePromo(prod.productData!.promo!)
                ? (prod.productData!.price! -
                    prod.productData!.promo!.promoPrice!)
                : 0,
            notes: prod.notes,
          );
          prods.add(prodTrx);
        }

        // mendapatkan data id shop
        idShop = prod.productData!.idShop!;
      }

      // membuat model untuk transaksi baru
      CreateTransactionModel createTrx = CreateTransactionModel(
        idUser: idUser,
        email: emailUser,
        idShop: idShop,
        takenDate: _selectedDate,
        products: prods,
      );

      // DMethod.log('JSON TRX : ${jsonEncode(createTrx)}');

      // Get.back();

      // call controller untuk transaksi
      final dataState = await _controller.createTrx(
        createTransaction: createTrx,
      );

      // close loading
      Get.back();

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation('Transaksi Berhasil');
        switch (_from) {
          case 1:
            {
              Get.back();
              Get.back();
              Get.back();
            }
          case 2:
            {
              Get.back();
              Get.back();
            }
        }
      }

      if (dataState is DataFailed) {
        PasarAjaUtils.triggerVibration();
        await PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      PasarAjaUtils.triggerVibration();
      await PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }
}
