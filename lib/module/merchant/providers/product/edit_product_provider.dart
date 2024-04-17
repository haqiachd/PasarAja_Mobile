import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/constants/local_data.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/choose_categories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/product_detail_page_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_settings_model.dart';

class EditProductProvider extends ChangeNotifier {
  final _controller = ProductController();
  ValidationModel vNama = PasarAjaValidation.productName(null);
  ValidationModel vDesc = PasarAjaValidation.descriptionProduct(null);
  ValidationModel vSelling = PasarAjaValidation.sellingUnit(null);
  ValidationModel vPrice = PasarAjaValidation.price(null);
  TextEditingController photoCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController categoryCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController sellingCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();

  int _idProductSelected = 0;

  // list unit
  List<String> _units = [];

  List<String> get units => _units;

  // list category
  List<ChooseCategoriesModel> _categories = [];

  List<ChooseCategoriesModel> get categories => _categories;

  // stok
  bool _isAvailable = false;

  bool get isAvailable => _isAvailable;

  set isAvailable(bool value) {
    _isAvailable = value;
    notifyListeners();
  }

  // rekomendasi
  bool _isRecommended = false;

  bool get isRecommended => _isRecommended;

  set isRecommended(bool value) {
    _isRecommended = value;
    if (_isRecommended) {
      _isShown = true;
    }
    notifyListeners();
  }

  // visibilty
  bool _isShown = false;

  bool get isShown => _isShown;

  set isShown(bool value) {
    _isShown = value;
    if (!_isShown) {
      _isRecommended = false;
    }
    notifyListeners();
  }

  // button state status
  int _buttonState = ActionButton.stateDisabledButton;

  int get buttonState => _buttonState;

  set buttonState(int n) {
    _buttonState = n;
    notifyListeners();
  }

  Object _message = '';

  Object get message => _message;

  set message(Object m) {
    _message = m;
    notifyListeners();
  }

  // selected category
  String _categoryProd = '';

  String get categoryProd => _categoryProd;

  set categoryProd(String m) {
    _categoryProd = m;
    notifyListeners();
  }

  // selected category
  set selectedCategoryName(String m) {
    categoryCont.text = m;
    notifyListeners();
  }

  // selected category id
  int _selectedCategoryId = 0;

  int get selectedCategoryId => _selectedCategoryId;

  set selectedCategoryId(int m) {
    _selectedCategoryId = m;
    notifyListeners();
  }

  // selected unit
  String _selectedUnit = '';

  String get selectedUnit => _selectedUnit;

  set selectedUnit(String m) {
    _selectedUnit = m;
    _updateButonState();
  }

  /// Untuk mengecek apakah nama yang diinputkan valid atau tidak
  ///
  void onValidateName(String email) {
    // mengecek nama valid atau tidak
    vNama = PasarAjaValidation.productName(email);

    // jika nama valid
    if (vNama.status == true) {
      _message = '';
    } else {
      _message = vNama.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  /// Untuk mengecek apakah satuan jual yang diinputkan valid atau tidak
  ///
  void onValidateSelling(String selling) {
    // mengecek satuan jual valid atau tidak
    vSelling = PasarAjaValidation.sellingUnit(selling);

    // jika desc satuan jual
    if (vSelling.status == true) {
      _message = '';
    } else {
      _message = vSelling.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  /// Untuk mengecek apakah price yang diinputkan valid atau tidak
  ///
  void onValidatePrice(String selling) {
    // mengecek price valid atau tidak
    vPrice = PasarAjaValidation.price(selling);

    // jika desc price
    if (vPrice.status == true) {
      _message = '';
    } else {
      _message = vPrice.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  void refreshDesc() {
    notifyListeners();
  }

  void _updateButonState() {
    DMethod.log("STATE : $_selectedUnit");
    if (vNama.status == null ||
        vSelling.status == null ||
        vPrice.status == null ||
        _selectedUnit.isEmpty) {
      _buttonState = ActionButton.stateDisabledButton;
    }
    if (vNama.status == false ||
        vSelling.status == false ||
        vPrice.status == false ||
        _selectedUnit == 'Pilih Unit') {
      _buttonState = ActionButton.stateDisabledButton;
    } else {
      _buttonState = ActionButton.stateEnabledButton;
    }
    notifyListeners();
  }

  Future<void> updateProduct() async {
    try {
      // create settings
      ProductSettingsModel settings = ProductSettingsModel(
        isAvailable: _isAvailable,
        isShown: _isShown,
        isRecommended: _isRecommended,
      );

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      PasarAjaMessage.showLoading();

      // call controller
      final dataState = await _controller.updateProduct(
        idShop: idShop,
        idProduct: _idProductSelected,
        idCategory: selectedCategoryId,
        productName: nameCont.text,
        description: descCont.text,
        unit: selectedUnit,
        sellingUnit: int.parse(sellingCont.text),
        settings: settings,
        price: int.parse(priceCont.text),
      );

      if (dataState is DataSuccess) {
        Get.back();
        await PasarAjaMessage.showInformation("Produk Berhasil Diupdate");
        Get.back();
        Get.back();
      }

      if (dataState is DataFailed) {
        Get.back();
        PasarAjaUtils.triggerVibration();
        PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
    }
  }

  Future<void> setData(ProductDetailModel detailProd) async {
    try {
      // get unit jual
      DataState dataState = await _controller.getUnits();
      if (dataState is DataSuccess) {
        _units = dataState.data as List<String>;
      }
      if (dataState is DataFailed) {
        _units = PasarAjaLocalData.defaultUnits;
      }

      // get product categories
      dataState = await _controller.listCategory(
        idShop: detailProd.idShop ?? 0,
      );
      if (dataState is DataSuccess) {
        _categories = dataState.data as List<ChooseCategoriesModel>;
      }

      if (dataState is DataFailed) {
        Fluttertoast.showToast(msg: "Gagal mendapatkan data kategori produk");
      }

      // save data to controller
      _idProductSelected = detailProd.idProduct ?? 0;
      _selectedCategoryId = detailProd.idCpProd ?? 0;
      photoCont = TextEditingController(text: detailProd.photo);
      nameCont = TextEditingController(text: detailProd.productName);
      categoryCont = TextEditingController(text: detailProd.categoryName);
      descCont = TextEditingController(text: detailProd.description);
      selectedUnit = detailProd.unit.toString();
      sellingCont = TextEditingController(
        text: detailProd.sellingUnit.toString(),
      );
      priceCont = TextEditingController(text: detailProd.price.toString());
      _isRecommended = detailProd.settings?.isRecommended ?? false;
      _isShown = detailProd.settings?.isShown ?? false;
      _isAvailable = detailProd.settings?.isAvailable ?? false;
      // validate data
      vNama = PasarAjaValidation.productName(nameCont.text);
      vDesc = PasarAjaValidation.descriptionProduct(descCont.text);
      vSelling = PasarAjaValidation.sellingUnit(sellingCont.text);
      vPrice = PasarAjaValidation.price(priceCont.text);
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
      buttonState = ActionButton.stateDisabledButton;
    }
  }
}
