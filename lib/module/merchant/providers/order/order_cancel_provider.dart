// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';

class OrderCancelProvider extends ChangeNotifier {
  // controller
  final _controller = OrderController();
  TextEditingController? pesanCont = TextEditingController(text: null);

  // state
  ProviderState state = const OnInitState();

  bool _tokoTutupRadio = false;
  bool get tokoTutupRadio => _tokoTutupRadio;
  set tokoTutupRadio(bool v) {
    _resetRadio();
    _tokoTutupRadio = v;
    notifyListeners();
  }

  bool _salahInfoRadio = false;
  bool get salahInfoRadio => _salahInfoRadio;
  set salahInfoRadio(bool v) {
    _resetRadio();
    _salahInfoRadio = v;
    notifyListeners();
  }

  bool _stokHabisRadio = false;
  bool get stokHabisRadio => _stokHabisRadio;
  set stokHabisRadio(bool v) {
    _resetRadio();
    _stokHabisRadio = v;
    notifyListeners();
  }

  bool _lainnyaRadio = false;
  bool get lainnyaRadio => _lainnyaRadio;
  set lainnyaRadio(bool v) {
    _resetRadio();
    _lainnyaRadio = v;
    notifyListeners();
  }

  String getSelectedMessage() {
    if (_tokoTutupRadio) {
      return 'Toko Tutup';
    }

    if (_salahInfoRadio) {
      return 'Kesalahan Informasi Produk';
    }

    if (_stokHabisRadio) {
      return 'Stok Sedang Habis';
    }

    if (_lainnyaRadio) {
      return 'Lainnya';
    }

    return 'null';
  }

  Future<void> cancelOrder({required String orderCode}) async {
    try {
      // cek apakah penjual sudah memilih alasan
      if (!_tokoTutupRadio &&
          !_salahInfoRadio &&
          !stokHabisRadio &&
          !lainnyaRadio) {
        await PasarAjaMessage.showWarning(
          'Silahkan pilih alasan pembatalan',
        );
        return;
      }

      // cek apakah penjual sudah menulis pesan
      if (pesanCont?.text == null ||
          pesanCont!.text.isEmpty ||
          pesanCont!.text.trim().isEmpty) {
        await PasarAjaMessage.showWarning(
          'Silahkan tulis alasan pembatalan',
        );
        return;
      }

      // show dialog konfirmasi
      bool confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda Yakin Ingin Membatalkan Pesanan",
        actionCancel: "Tidak Jadi",
        actionYes: "Iya",
      );

      if (!confirm) {
        return;
      }

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // show loading
      PasarAjaMessage.showLoading();

      // call controller
      final dataState = await _controller.cancelByMerchantTrx(
        idShop: idShop,
        orderCode: orderCode,
        reason: getSelectedMessage(),
        message: pesanCont!.text,
      );

      // close loading
      Get.back();

      // jika pesanan berhasil dibatalkan
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation(
          "Pesanan Berhasil Dibatalkan",
          actionYes: "OK",
        );

        Get.back();
      }

      // jika pesanan gagal dibatalkan
      if (dataState is DataFailed) {
        await PasarAjaMessage.showSnackbarError(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      await PasarAjaMessage.showWarning(
        ex.toString(),
      );
      Get.back();
    }
  }

  void _resetRadio() {
    _tokoTutupRadio = false;
    _salahInfoRadio = false;
    _stokHabisRadio = false;
    _lainnyaRadio = false;
  }

  void resetData() {
    _resetRadio();
    pesanCont?.text = '';
    notifyListeners();
  }

//
}
