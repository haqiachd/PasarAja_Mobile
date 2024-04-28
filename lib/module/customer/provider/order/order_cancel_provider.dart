import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';

class CustomerOrderCancelProvider extends ChangeNotifier {
  // controller
  final _controller = OrderController();
  TextEditingController? pesanCont = TextEditingController(text: null);

  // state
  ProviderState state = const OnInitState();

  bool _berubahPikiran = false;
  bool get berubahPikiran => _berubahPikiran;
  set berubahPikiran(bool v) {
    _resetRadio();
    _berubahPikiran = v;
    notifyListeners();
  }

  bool _gantiProduk = false;
  bool get gantiProduk => _gantiProduk;
  set gantiProduk(bool v) {
    _resetRadio();
    _gantiProduk = v;
    notifyListeners();
  }

  bool _responPenjual = false;
  bool get responsPenjual => _responPenjual;
  set responsPenjual(bool v) {
    _resetRadio();
    _responPenjual = v;
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
    if (_berubahPikiran) {
      return 'Berubah Pikiran';
    }

    if (_gantiProduk) {
      return 'Ingin Ganti Produk';
    }

    if (_responPenjual) {
      return 'Penjual Tidak Merespon';
    }

    if (_lainnyaRadio) {
      return 'Lainnya';
    }

    return 'null';
  }

  Future<void> cancelOrder({
    required int idShop,
    required String orderCode,
  }) async {
    try {
      // cek apakah penjual sudah memilih alasan
      if (!_berubahPikiran &&
          !_gantiProduk &&
          !responsPenjual &&
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

      // show loading
      PasarAjaMessage.showLoading();

      // call controller
      final dataState = await _controller.cancelByCustomerTrx(
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
    _berubahPikiran = false;
    _gantiProduk = false;
    _responPenjual = false;
    _lainnyaRadio = false;
  }

  void resetData() {
    _resetRadio();
    pesanCont?.text = '';
    notifyListeners();
  }
}
