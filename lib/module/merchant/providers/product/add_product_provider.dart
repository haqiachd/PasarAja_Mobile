import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/constants/local_data.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/action_button.dart';

class AddProductProvider extends ChangeNotifier {
  // controller, validation, state
  ValidationModel vNama = PasarAjaValidation.productName(null);
  ValidationModel vDesc = PasarAjaValidation.descriptionProduct(null);
  ValidationModel vSelling = PasarAjaValidation.sellingUnit(null);
  ValidationModel vPrice = PasarAjaValidation.price(null);
  final _controller = ProductController();
  final nameCont = TextEditingController();
  final descCont = TextEditingController();
  final unitCont = TextEditingController();
  final sellingCont = TextEditingController();
  final priceCont = TextEditingController();
  final categoryCont = TextEditingController();
  ProviderState state = const OnInitState();

  // list unit
  List<String> _units = [];
  List<String> get units => _units;

  // file photo product
  ChoosePhotoEntity _photo = const ChoosePhotoEntity(
    image: null,
    imageSelected: null,
  );
  ChoosePhotoEntity get photo => _photo;
  set photo(ChoosePhotoEntity p) {
    _photo = p;
    notifyListeners();
  }

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

  // error message
  String _selectedUnit = '';
  String get selectedUnit => _selectedUnit;
  set selectedUnit(String m) {
    _selectedUnit = m;
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
  bool _isShown = true;
  bool get isShown => _isShown;
  set isShown(bool value) {
    _isShown = value;
    if (!_isShown) {
      _isRecommended = false;
    }
    notifyListeners();
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
    if (vNama.status == null ||
        vSelling.status == null ||
        vPrice.status == null) {
      _buttonState = ActionButton.stateDisabledButton;
    }
    if (vNama.status == false ||
        vSelling.status == false ||
        vPrice.status == false) {
      _buttonState = ActionButton.stateDisabledButton;
    } else {
      _buttonState = ActionButton.stateEnabledButton;
    }
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

      DMethod.log("Nama : ${nameCont.text}");
      DMethod.log("Category : ${categoryCont.text}");
      DMethod.log("Deskripsi : ${descCont.text}");
      DMethod.log("Unit : ${descCont.text}");
      DMethod.log("Satuan Jual : ${sellingCont.text}");
      DMethod.log("Harag : ${priceCont.text}");
      DMethod.log("File : ${photo.path}");

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
        state = OnFailureState(
          message: dataState.error?.error.toString(),
          dioException: dataState.error,
        );
      }

      notifyListeners();
    } catch (ex) {
      state = const OnFailureState();
      message = ex.toString();
    }
  }

  Future<void> resetData() async {
    // get unit jual
    final dataState = await _controller.getUnits();
    if (dataState is DataSuccess) {
      _units = dataState.data as List<String>;
    }
    if (dataState is DataFailed) {
      _units = PasarAjaLocalData.defaultUnits;
    }
    _selectedUnit = 'Pilih Unit';
    nameCont.text = '';
    descCont.text = '';
    categoryCont.text = '';
    unitCont.text = '';
    sellingCont.text = '';
    priceCont.text = '';
    _isRecommended = false;
    _isShown = true;
    _buttonState = ActionButton.stateDisabledButton;
    vNama = PasarAjaValidation.name(null);
    vDesc = PasarAjaValidation.descriptionProduct(null);
    vSelling = PasarAjaValidation.sellingUnit(null);
    vPrice = PasarAjaValidation.price(null);
    notifyListeners();
  }
}
