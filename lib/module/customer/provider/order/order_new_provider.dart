import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/models/create_transaction_model.dart';

class CustomerOrderNewProvider extends ChangeNotifier {
  final _orderController = OrderController();
  TextEditingController takenDateCont = TextEditingController();

  int _from = 0;
  int get from => _from;
  set from(int i){
    _from = i;
    notifyListeners();
  }

  int _totalProduct = 0;
  int get totalProduct => _totalProduct;

  int _subTotal = 0;
  int get subTotal => _subTotal;

  int _totalPromo = 0;
  int get totalPromo => _totalPromo;

  int _totalPrice = 0;
  int get totalPrice => _totalPrice;

  String _selectedDate = '';
  String get selectedDate => _selectedDate;

  CartModel _cartModel = CartModel();
  CartModel get cartModel => _cartModel;

  set cartModel(CartModel c) {
    _cartModel = c;
    notifyListeners();
  }

  void init() {
    // reset data
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    takenDateCont.text = PasarAjaUtils.formatDateString(_selectedDate);
    _totalProduct = 0;
    _subTotal = 0;
    _totalPromo = 0;
    _totalPrice = 0;

    // hitung rician pembayaran
    for (var prod in cartModel.products!) {
      if (prod.checked) {
        _totalProduct++;
        _subTotal += (prod.productData!.price! * prod.quantity!);
        _totalPromo += PasarAjaUtils.isActivePromo(prod.productData!.promo!)
            ? (prod.productData!.price! -
                    prod.productData!.promo!.promoPrice!) *
                prod.quantity!
            : 0;
      }
    }
    _totalPrice = (_subTotal - _totalPromo);

    notifyListeners();
  }

  Future<void> selectTakenDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime oneWeek = today.add(const Duration(days: 7));

    // show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: oneWeek,
      confirmText: "Pilih",
      cancelText: "Batal",
    );

    // jika user memilih tanggal
    if (pickedDate != null) {
      // Format tanggal sesuai dengan kebutuhan (yyyy-MM-dd)
      _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      takenDateCont.text = PasarAjaUtils.formatDateString(_selectedDate);
      notifyListeners();
    }
  }

  Future<void> onCreateOrderButtonPressed() async {
    try {
      final confirm = await PasarAjaMessage.showConfirmation(
        'Apakah Anda Yakin Ingin Membuat Pesanan?',
      );

      if (!confirm) {
        return;
      }

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
        DMethod.log('id prod : ${prod.idProduct}');
        DMethod.log('prod name : ${prod.productData!.productName}');
        DMethod.log('quantity : ${prod.quantity}');
        DMethod.log(
            'promo price : ${PasarAjaUtils.isActivePromo(prod.productData!.promo!) ? (prod.productData!.price! - prod.productData!.promo!.promoPrice!) : 0}');
        DMethod.log('notes : ${prod.notes}');
        DMethod.log('-' * 10);

        if(prod.checked){
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

      // call controller untuk transaksi
      final dataState = await _orderController.createTrx(
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
            }
          case 2:
            {
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
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      PasarAjaUtils.triggerVibration();
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }
}
