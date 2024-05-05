import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/controllers/cart_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_product_model.dart';

class CartProvider extends ChangeNotifier {
  final _cartController = CartController();
  ProviderState state = const OnInitState();

  int _totalPriceSelected = 0;
  int get totalPriceSelected => _totalPriceSelected;

  int _selectedShop = 0;
  int get selectedShop => _selectedShop;

  List<CartModel> carts = [];

  Future<void> fetchData() async {
    try {
      state = const OnLoadingState();
      notifyListeners();

      final int idUser = await PasarAjaUserService.getUserId();

      final dataState = await _cartController.fetchListCart(idUser: idUser);

      if (dataState is DataSuccess) {
        carts = dataState.data as List<CartModel>;
        state = const OnSuccessState();
        _totalPriceSelected = 0;
        notifyListeners();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(dioException: dataState.error);
        notifyListeners();
      }
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  void checkedAll(int index) {
    // carts[index].checkedAll = !carts[index].checkedAll;
    // for(var prods in carts[index].products!){
    //   prods.checked = carts[index].checkedAll;
    // }
    // if(!carts[index].checkedAll){
    //   _totalPriceSelected = 0;
    // }else{
    //   for()
    // }
    // notifyListeners();
  }

  void checkboxChange(CartProductModel cartProd) {
    _updateTotalPrice(cartProd);
    cartProd.checked = !cartProd.checked;

    if (cartProd.productData?.idShop != _selectedShop) {
      _totalPriceSelected = 0;
      for (var cart in carts) {
        if (cart.idShop == _selectedShop) {
          for (var prod in cart.products!) {
            prod.checked = false;
          }
        }
      }
      notifyListeners();
    }

    if (cartProd.checked == true) {
      _totalPriceSelected += cartProd.totalPrice ?? 0;
    } else {
      _totalPriceSelected -= cartProd.totalPrice ?? 0;
    }
    _selectedShop = cartProd.productData?.idShop ?? 0;
    notifyListeners();
  }

  void _updateTotalPrice(CartProductModel cartProd) {
    cartProd.totalPrice =
        PasarAjaUtils.isActivePromo(cartProd.productData!.promo!)
            ? cartProd.productData!.promo!.promoPrice!
            : cartProd.productData!.price!;

    cartProd.totalPrice = (cartProd.totalPrice! * cartProd.quantity!).toInt();
  }

  void updateQuantity(BuildContext context, CartProductModel cartProd) async {
    final newQty = await showQtyDialog(context, cartProd, cartProd.quantity!);

    if(newQty != -1){
      _totalPriceSelected -= cartProd.totalPrice!;
      cartProd.quantity = newQty;
      cartProd.controller = TextEditingController(text: '$newQty');
      cartProd.onChages = true;

      _updateTotalPrice(cartProd);

      _totalPriceSelected += cartProd.totalPrice!;

      notifyListeners();
    }
  }

  void plusOneQuantity(CartProductModel cartProd) {
    // quantity max 99
    if (cartProd.quantity! >= 99) {
      Fluttertoast.showToast(msg: 'jumlah produk maksimal 99');
      return;
    }

    // update quantity
    cartProd.quantity = (cartProd.quantity! + 1);
    cartProd.controller = TextEditingController(text: '${cartProd.quantity}');
    cartProd.onChages = true;
    if (cartProd.checked) {
      _totalPriceSelected -= cartProd.totalPrice ?? 0;
    }

    // update price and state
    _updateTotalPrice(cartProd);
    if (cartProd.checked) {
      _totalPriceSelected += cartProd.totalPrice ?? 0;
    }
    notifyListeners();
  }

  void minusOneQuantity(CartProductModel cartProd) {
    // quantity min 1
    if (cartProd.quantity! <= 1) {
      Fluttertoast.showToast(msg: 'jumlah produk minimal 1');
      return;
    }

    // update quantity
    cartProd.quantity = (cartProd.quantity! - 1);
    cartProd.controller = TextEditingController(text: '${cartProd.quantity}');
    cartProd.onChages = true;

    if (cartProd.checked) {
      _totalPriceSelected -= cartProd.totalPrice ?? 0;
    }
    // update price and state
    _updateTotalPrice(cartProd);
    if (cartProd.checked) {
      _totalPriceSelected += cartProd.totalPrice ?? 0;
    }
    notifyListeners();
  }

  Future<void> saveChanges(CartProductModel cartProd) async {
    try {
      PasarAjaMessage.showLoading();

      final idUser = await PasarAjaUserService.getUserId();

      final dataState = await _cartController.addCart(
        idUser: idUser,
        idShop: cartProd.productData!.idShop!,
        product: cartProd.productData!,
        quantity: cartProd.quantity!,
        notes: cartProd.notes!,
        promoPrice: cartProd.promoPrice!,
      );

      Get.back();

      if (dataState is DataSuccess) {
        cartProd.onChages = false;
        notifyListeners();
        Fluttertoast.showToast(msg: 'quantity diupdate');
      }

      if (dataState is DataFailed) {
        PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }

  Future<void> addNotes(BuildContext context, CartProductModel cartProd) async {
    try {
      final notes =
          await showNotesDialog(context, cartProd, cartProd.notes ?? '');

      if ((notes ?? '') != '###') {
        final idUser = await PasarAjaUserService.getUserId();

        PasarAjaMessage.showLoading();

        final dataState = await _cartController.addCart(
          idUser: idUser,
          idShop: cartProd.productData!.idShop!,
          product: cartProd.productData!,
          quantity: cartProd.quantity!,
          notes: notes ?? '',
          promoPrice: cartProd.promoPrice!,
        );

        Get.back();

        if (dataState is DataSuccess) {
          notifyListeners();
          cartProd.notes = notes;
          Fluttertoast.showToast(msg: 'Catatan berhasil diupdate');
        }

        if (dataState is DataFailed) {
          PasarAjaMessage.showSnackbarWarning(
            dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
          );
        }
      }
    } catch (ex) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }

  Future<void> deleteProduct(CartProductModel cartProd) async {
    try {
      final confirm = await PasarAjaMessage.showConfirmation(
        "Apakah Anda Yakin Ingin Menghapus Produk '${cartProd.productData?.productName ?? 'null'}' dari Kerajang?",
        barrierDismissible: true,
        actionYes: 'Yakin',
        actionCancel: 'Batal',
      );

      if (!confirm) {
        return;
      }

      PasarAjaMessage.showLoading();

      final idUser = await PasarAjaUserService.getUserId();

      final dataState = await _cartController.removeCart(
        idUser: idUser,
        idShop: cartProd.productData?.idShop ?? 0,
        idProduct: cartProd.productData?.id ?? 0,
      );

      Get.back();

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation(
          'Produk Berhasil Dihapus dari Keranjang',
        );
        CartModel? cartTemp = carts.firstWhere(
            (element) => element.idShop == cartProd.productData?.idShop);
        cartTemp.products!
            .removeWhere((item) => item.idProduct == cartProd.idProduct);
        notifyListeners();

        for (var prod in cartTemp.products!) {
          DMethod.log('product name : ${prod.productData?.productName}');
        }
      }

      if (dataState is DataFailed) {
        PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }

  Future<String?> showNotesDialog(
      BuildContext context, CartProductModel cartProd, String oldValue) async {
    TextEditingController textController =
        TextEditingController(text: oldValue);
    String? enteredText;

    // Tampilkan dialog
    await showDialog(
      context: context,
      barrierDismissible: false, // nonaktifkan dismissable
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Catatan"),
          content: TextField(
            controller: textController,
            maxLength: 100,
            style: PasarAjaTypography.sfpdRegular,
            decoration: InputDecoration(hintText: "Masukkan catatan..."),
            maxLines: null, // Bisa menambahkan beberapa baris teks
          ),
          actions: <Widget>[
            // Tombol Batal
            TextButton(
              onPressed: () {
                enteredText = '###';
                Navigator.of(context)
                    .pop(null); // Tutup dialog tanpa mengembalikan data
              },
              child: Text("Batal"),
            ),
            // Tombol Simpan
            ElevatedButton(
              onPressed: () {
                enteredText = textController.text; // Ambil teks yang dimasukkan
                Navigator.of(context)
                    .pop(enteredText); // Tutup dialog dan kembalikan teks
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );

    return enteredText; // Kembalikan teks yang dimasukkan (null jika tombol batal ditekan)
  }

  Future<int?> showQtyDialog(
      BuildContext context, CartProductModel cartProd, int oldValue) async {
    TextEditingController textController =
        TextEditingController(text: '$oldValue');
    int? enteredQty;

    // Tampilkan dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ubah Jumlah"),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: PasarAjaTypography.sfpdSemibold,
            inputFormatters: AppTextField.numberFormatter(),
            decoration:
                const InputDecoration(hintText: "Masukkan Jumlah Produk"),
            maxLines: 1,
          ),
          actions: <Widget>[
            // Tombol Batal
            TextButton(
              onPressed: () {
                enteredQty = -1;
                Navigator.of(context)
                    .pop(null); // Tutup dialog tanpa mengembalikan data
              },
              child: const Text("Batal"),
            ),
            // Tombol Simpan
            ElevatedButton(
              onPressed: () {
                // cek apakah jumlah kosong
                if (textController.text.trim().isEmpty) {
                  Fluttertoast.showToast(msg: 'Jumlah tidak boleh kosong');
                  return;
                }
                // get jumlah
                int val = int.parse(textController.text);
                // cek validasi jumlah
                if (val <= 0) {
                  Fluttertoast.showToast(msg: 'jumlah minimal 1');
                  return;
                } else if (val > 99) {
                  Fluttertoast.showToast(msg: 'jumlah maksimal 99');
                  return;
                }

                // update jumlah
                enteredQty = val;
                Get.back();
              },
              child: const Text("Ubah"),
            ),
          ],
        );
      },
    );

    return enteredQty;
  }
}
