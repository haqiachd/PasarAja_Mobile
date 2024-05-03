import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/customer/controllers/cart_controller.dart';
import 'package:pasaraja_mobile/module/customer/controllers/shopping_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/product_detail_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class CustomerProductDetailProvider extends ChangeNotifier {
  final _controller = ShoppingController();
  final _cartController = CartController();
  TextEditingController quantityCont = TextEditingController();

  ProviderState state = const OnInitState();
  ProductDetailModel _productDetail = const ProductDetailModel();

  ProductDetailModel get productDetail => _productDetail;

  int _priceSelected = 0;

  int get priceSelected => _priceSelected;

  set priceSelected(int p) {
    _priceSelected = p;
    notifyListeners();
  }

  int _price = 0;

  int get price => _price;

  set price(int p) {
    _price = p;
    notifyListeners();
  }

  int _quantity = 1;

  int get quantity => _quantity;

  set quantity(int q) {
    _quantity = q;
    if (_quantity <= 0) {
      _quantity = 0;
      return;
    }
    if (_quantity >= 99) {
      _quantity = 99;
      return;
    }
    _price = _priceSelected * _quantity;
    quantityCont = TextEditingController(text: '$_quantity');
    notifyListeners();
  }

  Future<void> fetchData({required int idShop, required int idProduct}) async {
    try {
      _quantity = 0;
      _priceSelected = 0;
      _price = 0;
      quantityCont = TextEditingController(text: '$_quantity');
      state = const OnLoadingState();
      notifyListeners();

      final dataState = await _controller.fetchProdDetail(
        idShop: idShop,
        idProduct: idProduct,
      );

      if (dataState is DataSuccess) {
        _productDetail = dataState.data as ProductDetailModel;
        state = const OnSuccessState();
        notifyListeners();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          message: dataState.error?.error.toString() ??
              PasarAjaConstant.unknownError,
        );
        notifyListeners();
      }
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> onButtonAddCartPressed() async {
    try {
      final idUser = 3;

      PasarAjaMessage.showLoading(loadingColor: Colors.white);

      final dataState = await _cartController.addCart(
        idUser: idUser,
        idShop: 1,
        product: _productDetail.products!,
        quantity: quantity,
        notes: '',
        promoPrice: 0,
      );

      Get.back();

      if(dataState is DataSuccess){
        await PasarAjaMessage.showInformation("Produk Ditambahkan ke Keranjang");
      }

      if(dataState is DataFailed){
        await PasarAjaMessage.showWarning("Produk Gagal Ditambahkan");
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: "error : ${ex.toString()}");
    }
  }
}
