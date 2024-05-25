import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/models/create_transaction_model.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_pin_verify_page.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/myshop_controller.dart';

class CustomerOrderNewProvider extends ChangeNotifier {
  final _orderController = OrderController();
  TextEditingController takenDateCont = TextEditingController();

  List<int> tutup = [];

  int _from = 0;

  int get from => _from;

  set from(int i) {
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

  LocalAuthentication? _auth;

  bool _supportState = false;

  bool get supportState => _supportState;

  Future<void> init() async{
    // reset data
    _selectedDate = '';
    takenDateCont.text = '';
    _totalProduct = 0;
    _subTotal = 0;
    _totalPromo = 0;
    _totalPrice = 0;

    var shopCont = MyShopController();

    PasarAjaMessage.showLoading();

    // Mendapatkan hari toko tutup
    tutup = await shopCont.getCloseDays(_cartModel.idShop!);

    Get.back(); // Assuming Get is used for navigation and can be accessed globally


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

    _auth = LocalAuthentication();
    _auth!.isDeviceSupported().then((value) {
      _supportState = value;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> selectTakenDate(BuildContext context) async {

    final DateTime today = DateTime.now();
    final DateTime oneWeek = today.add(Duration(days: (7 + tutup.length)));

    // Find the next selectable date from today
    DateTime nextSelectableDate = today;
    while (tutup.contains(nextSelectableDate.weekday)) {
      nextSelectableDate = nextSelectableDate.add(const Duration(days: 1));
    }

    try {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: nextSelectableDate,
        firstDate: today,
        lastDate: oneWeek,
        confirmText: "Pilih",
        cancelText: "Batal",
        selectableDayPredicate: (DateTime date) {
          // Disable hari yang tutup DAN BERI WARNA MERAH PADA TANGGAL
          return !tutup.contains(date.weekday);
        },
      );

      // Jika user memilih tanggal
      if (pickedDate != null) {
        // Format tanggal sesuai dengan kebutuhan (yyyy-MM-dd)
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        takenDateCont.text = PasarAjaUtils.formatDateString(_selectedDate);
        notifyListeners();
      }
    } catch (ex) {
      DMethod.log('exception : $ex');
    }
  }

  Future<dynamic> _showSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: Get.width,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Pilih Mode Verifikasi',
                  style: PasarAjaTypography.bold16,
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _supportState,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width,
                        child: OutlinedButton(
                          onPressed: () async {
                            await verifyBiometrics();
                          },
                          child: Text(
                            'Sidik Jari',
                            style: PasarAjaTypography.bold14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      Get.to(
                        OrderPinVerifyPage(
                          from: _from,
                          selectedDate: _selectedDate,
                          cartModel: _cartModel,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Text(
                      'PIN PasarAja',
                      style: PasarAjaTypography.bold14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> verifyBiometrics() async {
    try {
      await getAvailableBiometrics();
      bool authenticated = await _auth!.authenticate(
        localizedReason:
            'Silakan verifikasi sidik jari Anda untuk memastikan identitas Anda.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        await _createOrder();
      }
    } on PlatformException catch (e) {
      DMethod.log('exception on biometric : $e');
    }
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await _auth!.getAvailableBiometrics();

    DMethod.log('list of bio : $availableBiometrics');
  }

  Future<void> onCreateOrderButtonPressed() async {
    try {
      if (_selectedDate.trim().isEmpty) {
        await PasarAjaMessage.showWarning(
          'Anda belum memilih tanggal pengambilan!',
          actionYes: 'OK',
          barrierDismissible: true,
        );
        return;
      }

      final confirm = await PasarAjaMessage.showConfirmation(
        'Apakah Anda Yakin Ingin Membuat Pesanan?',
      );

      if (!confirm) {
        return;
      }

      // tampilkan bottom sheet dengan get x untuk memilih inputan sidik jari atau pin
      _showSheet(Get.context!);
    } catch (ex) {
      PasarAjaUtils.triggerVibration();
      PasarAjaMessage.showSnackbarWarning(ex.toString());
    }
  }

  Future<void> _createOrder() async {
    try {
      PasarAjaMessage.showLoading(loadingColor: Colors.white);

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
