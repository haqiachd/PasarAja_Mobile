import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/constants/local_data.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_settings_model.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/crop_photo_page.dart';

class AddProductProvider extends ChangeNotifier {
  // controller, validation, state
  ValidationModel vNama = PasarAjaValidation.productName(null);
  ValidationModel vDesc = PasarAjaValidation.descriptionProduct(null);
  ValidationModel vSelling = PasarAjaValidation.sellingUnit(null);
  ValidationModel vPrice = PasarAjaValidation.price(null);
  final _controller = ProductController();
  final nameCont = TextEditingController();
  final descCont = TextEditingController();
  final sellingCont = TextEditingController();
  final priceCont = TextEditingController();
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

  Future<void> photoPicker(
    ImageSource imageSource,
    int idCategory,
    String categoryName,
  ) async {
    // choose photo
    _photo = await PasarAjaUtils.pickPhoto(imageSource) as ChoosePhotoEntity;
    notifyListeners();

    // jika user memilih foto
    if (_photo.imageSelected != null) {
      // crop foto
      final crop = await PasarAjaUtils.cropImage(
        _photo.imageSelected!,
      );

      // buka halaman add photo
      Get.off(
        CropPhotoPage(
          idProduct: 0,
          imageFile: crop!,
          type: CropPhotoPage.fromAddProduct,
          idCategory: idCategory,
          categoryName: categoryName,
        ),
        transition: Transition.cupertino,
      );
    }
  }

  Future<void> addProduct({
    required int idCategory,
  }) async {
    try {
      // print data
      DMethod.log("----------------------");
      DMethod.log("Nama : ${nameCont.text}");
      DMethod.log("Category : $idCategory");
      DMethod.log("Deskripsi : ${descCont.text}");
      DMethod.log("Unit : $selectedUnit");
      DMethod.log("Satuan Jual : ${sellingCont.text}");
      DMethod.log("Harga : ${priceCont.text}");
      DMethod.log("File : ${photo.imageSelected?.path}");
      DMethod.log('Tampilkan Produk : $isShown');
      DMethod.log('Rekomendasikan Produk : $isRecommended');

      // validasi data unit
      if (selectedUnit == 'Pilih Unit') {
        PasarAjaUtils.triggerVibration();
        PasarAjaMessage.showSnackbarWarning('Anda belum memilih unit jual');
        return;
      }
      // validasi data foto
      if (photo.imageSelected == null || photo.imageSelected?.path == null) {
        PasarAjaUtils.triggerVibration();
        PasarAjaMessage.showSnackbarWarning('Anda belum memilih foto produk');
        return;
      }
      // validasi ukuran foto
      File? imageFile = File(photo.imageSelected!.path);
      int fileSizeInBytes = imageFile.lengthSync();
      int maxSizeInBytes = 512 * 1024; // 512 KB
      if (fileSizeInBytes > maxSizeInBytes) {
        PasarAjaUtils.triggerVibration();
        PasarAjaMessage.showSnackbarWarning(
            'Ukuran file foto melebihi batas maksimum (512 KB)');
        return;
      }

      // show loading
      PasarAjaMessage.showLoading();

      // create product setting
      final settings = ProductSettingsModel(
        isAvailable: true,
        isRecommended: isRecommended,
        isShown: isShown,
      );

      DMethod.log("Settings : ${settings.toJson()}");
      DMethod.log("----------------------");

      DMethod.log("VALIDATE SUCCESS");

      // get id shop from preferences
      final int idShop = await PasarAjaUserService.getShopId();

      // call controller
      final dataState = await _controller.addProduct(
        idShop: idShop,
        idCategory: idCategory,
        productName: nameCont.text,
        description: descCont.text,
        unit: selectedUnit,
        sellingUnit: int.parse(sellingCont.text),
        photo: photo.imageSelected!,
        price: int.parse(priceCont.text),
        settings: settings,
      );

      Get.back();

      // produk berhasil disimpan
      if (dataState is DataSuccess) {
        DMethod.log('product ditambahkan');
        await PasarAjaMessage.showInformation("Produk berhasil ditambahkan");
        Get.back();
        Get.back();
        notifyListeners();
      }

      // // produk gagal disimpan
      if (dataState is DataFailed) {
        _message = dataState.error?.error.toString() ?? '';
        DMethod.log('product gagal ditambahkan --> $_message');
        PasarAjaMessage.showWarning(_message.toString());
        notifyListeners();
      }
    } catch (ex) {
      DMethod.log('has exception');
      message = ex.toString();
      PasarAjaMessage.showWarning(_message.toString());
      Get.back();
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
    sellingCont.text = '';
    priceCont.text = '';
    _isRecommended = false;
    _isShown = true;
    photo = const ChoosePhotoEntity(image: null, imageSelected: null);
    _buttonState = ActionButton.stateDisabledButton;
    vNama = PasarAjaValidation.name(null);
    vDesc = PasarAjaValidation.descriptionProduct(null);
    vSelling = PasarAjaValidation.sellingUnit(null);
    vPrice = PasarAjaValidation.price(null);
    notifyListeners();
  }
}
