import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/controllers/cart_controller.dart';
import 'package:pasaraja_mobile/module/customer/controllers/shopping_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_detail_model.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_new_page.dart';

class CustomerProductDetailProvider extends ChangeNotifier {
  final _controller = ShoppingController();
  final _cartController = CartController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController notesCont = TextEditingController();

  ProviderState state = const OnInitState();

  ProductDetailModel _productDetail = const ProductDetailModel();

  ProductDetailModel get productDetail => _productDetail;

  int _buttonState = ActionButton.stateEnabledButton;

  int get buttonState => _buttonState;

  // harga per satu unit produk di keranjang
  int _unitCartPrice = 0;

  int get unitCartPrice => _unitCartPrice;

  // total harga dari produk di keranjang
  int _totalCartPrice = 0;

  int get totalCartPrice => _totalCartPrice;

  int _quantity = 1;

  int get quantity => _quantity;

  set quantity(int q) {
    _quantity = q;

    _totalCartPrice = _unitCartPrice * _quantity;
    quantityCont = TextEditingController(text: '$_quantity');
    notifyListeners();
  }

  void resetQuantity() {
    _quantity = 1;
  }

  // only for buy now
  void onChangeQuantity(int qty) {
    if (qty <= 0) {
      Fluttertoast.showToast(msg: 'jumlah produk minimal 1');
      return;
    }

    if (qty >= 99) {
      Fluttertoast.showToast(msg: 'jumlah produk maksimal 99');
      return;
    }

    _quantity = qty;
    quantityCont.text = '$qty';
    notifyListeners();
  }

  void addOne() {
    DMethod.log('cart $_quantity ++1');
    // update quantity
    quantity = ++_quantity;

    // cek quantity
    if (_quantity >= 99) {
      quantity = 99;
      Fluttertoast.showToast(msg: 'jumlah produk maksimal 99');
      return;
    }
  }

  void minusOne() {
    DMethod.log('cart $_quantity --1');
    // update quantity
    quantity = --_quantity;

    // cek quantity
    if (_quantity <= 0) {
      quantity = 1;
      Fluttertoast.showToast(msg: 'jumlah produk minimal 1');
      return;
    }
  }

  Future<void> fetchData({required int idShop, required int idProduct}) async {
    try {
      // reset data cart
      _quantity = 0;
      _unitCartPrice = 0;
      _totalCartPrice = 0;
      notesCont.text = '';
      quantityCont.text = '$_quantity';

      // show loading
      state = const OnLoadingState();
      notifyListeners();

      final dataState = await _controller.fetchProdDetail(
        idShop: idShop,
        idProduct: idProduct,
      );

      if (dataState is DataSuccess) {
        _productDetail = dataState.data as ProductDetailModel;
        state = const OnSuccessState();

        // set cart data
        _quantity = 1;
        _unitCartPrice =
            PasarAjaUtils.isActivePromo(_productDetail.product!.promo!)
                ? _productDetail.product!.promo!.promoPrice!
                : _productDetail.product!.price!;
        _totalCartPrice = _unitCartPrice * _quantity;
        quantityCont = TextEditingController(text: '$_quantity');

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
      final idUser = await PasarAjaUserService.getUserId();

      PasarAjaMessage.showLoading(loadingColor: Colors.white);

      final dataState = await _cartController.addCart(
        idUser: idUser,
        idShop: _productDetail.product!.idShop!,
        product: _productDetail.product!,
        quantity: quantity,
        notes: '',
        promoPrice: PasarAjaUtils.isActivePromo(_productDetail.product!.promo!)
            ? _productDetail.product!.promo!.promoPrice!
            : _productDetail.product!.price!,
      );

      Get.back();

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation(
            "Produk Ditambahkan ke Keranjang");
      }

      if (dataState is DataFailed) {
        await PasarAjaMessage.showWarning("Produk Gagal Ditambahkan");
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: "error : ${ex.toString()}");
    }
  }

  Future<void> onButtonBuyNowPressed() async {
    try {
      final idUser = await PasarAjaUserService.getUserId();

      PasarAjaMessage.showLoading(loadingColor: Colors.white);

      DMethod.log('id user : ${idUser}');
      DMethod.log('is shop : ${_productDetail.product!.idShop!}');
      DMethod.log('id product : ${_productDetail.product!.id!}');
      DMethod.log('product : ${_productDetail.product!}');
      DMethod.log('quantity : ${quantity}');
      DMethod.log('notes : ${notesCont.text}');
      DMethod.log(
          'promo price : ${PasarAjaUtils.isActivePromo(_productDetail.product!.promo!) ? _productDetail.product!.promo!.promoPrice! : _productDetail.product!.price!}');

      final dataState = await _cartController.addCart(
        idUser: idUser,
        idShop: _productDetail.product!.idShop!,
        product: _productDetail.product!,
        quantity: quantity,
        notes: notesCont.text,
        promoPrice: PasarAjaUtils.isActivePromo(_productDetail.product!.promo!)
            ? _productDetail.product!.promo!.promoPrice!
            : _productDetail.product!.price!,
      );

      if (dataState is DataSuccess) {
        final cartState = await _cartController.fetchListCart(idUser: idUser);

        if (cartState is DataSuccess) {
          final cartsData = cartState.data;
          CartModel? cartTemp = cartsData?.firstWhere(
              (element) => element.idShop == _productDetail.product!.idShop!);

          for (var prod in cartTemp!.products!) {
            DMethod.log('prod name : ${prod.productData?.productName}');
            if (prod.idProduct == _productDetail.product?.id) {
              prod.checked = true;
            }
          }

          Get.back();

          Get.to(
            OrderNewPage(
              from: OrderNewPage.fromCart,
              cart: cartTemp,
            ),
            transition: Transition.rightToLeft,
          );
        }

        if (cartState is DataFailed) {
          Get.back();
          await PasarAjaMessage.showWarning("Gagal Memesan Produk");
        }
      }

      if (dataState is DataFailed) {
        Get.back();
        await PasarAjaMessage.showWarning("Gagal Memesan Produk");
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: "error : ${ex.toString()}");
    }
  }

  Future<void> chat() async {
    var phone = _productDetail.shopData!.phoneNumber;
    DMethod.log('chat to : $phone');
    bool confirm = await PasarAjaMessage.showConfirmation(
      'Anda akan diarahkan ke aplikasi WhatsApp',
      actionCancel: 'Batal',
      actionYes: 'Buka',
    );

    if(!confirm){
      return;
    }

    await PasarAjaUtils.launchURL('https://wa.me/$phone');
  }
}
