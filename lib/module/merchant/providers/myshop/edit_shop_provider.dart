import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/core/utils/validations.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/myshop_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/order/shop_data_model.dart';
import 'package:pasaraja_mobile/module/merchant/views/myshop/crop_photo_shop_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/crop_photo_page.dart';

class EditShopProvider extends ChangeNotifier {

  int _buttonState = ActionButton.stateDisabledButton;
  int get buttonState => _buttonState;
  set buttonState(int n) {
    _buttonState = n;
    notifyListeners();
  }

  final _controller = MyShopController();

  TextEditingController nameCont = TextEditingController();
  TextEditingController noHpCont = TextEditingController();
  TextEditingController benchmarkCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController photoCont = TextEditingController();

  ValidationModel vName = PasarAjaValidation.shopName(null);
  ValidationModel vNoHp = PasarAjaValidation.phone(null);
  ValidationModel vBench = PasarAjaValidation.shopBenchmark(null);

  ChoosePhotoEntity _photo = const ChoosePhotoEntity(
    image: null,
    imageSelected: null,
  );
  ChoosePhotoEntity get photo => _photo;
  set photo(ChoosePhotoEntity p) {
    _photo = p;
    notifyListeners();
  }

  void init(ShopDataModel shop) {
    nameCont.text = shop.shopName ?? '';
    noHpCont.text = (shop.phoneNumber ?? '62').substring(2);
    benchmarkCont.text = shop.benchmark ?? '';
    descCont.text = shop.description ?? '';
    photoCont.text = shop.photo ?? '';

    vName = PasarAjaValidation.name(nameCont.text);
    vNoHp = PasarAjaValidation.name(noHpCont.text);
    vBench = PasarAjaValidation.name(benchmarkCont.text);

    _updateButonState();

    notifyListeners();
  }

  Object _message = '';

  Object get message => _message;

  set message(Object m) {
    _message = m;
    notifyListeners();
  }

  /// Untuk mengecek apakah nama yang diinputkan valid atau tidak
  ///
  void onValidateName(String name) {
    // mengecek nama valid atau tidak
    vName = PasarAjaValidation.shopName(name);

    // jika nama valid
    if (vName.status == true) {
      _message = '';
    } else {
      _message = vName.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  /// Untuk mengecek apakah phone yang diinputkan valid atau tidak
  ///
  void onValidatePhone(String phone) {
    // mengecek nohp valid atau tidak
    vNoHp = PasarAjaValidation.phone(phone);

    // jika nohp valid
    if (vNoHp.status == true) {
      _message = '';
    } else {
      _message = vNoHp.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  /// Untuk mengecek apakah phone yang diinputkan valid atau tidak
  ///
  void onValidateBench(String bench) {
    // mengecek lokasi valid atau tidak
    vBench = PasarAjaValidation.shopBenchmark(bench);

    // jika lokasi valid
    if (vBench.status == true) {
      _message = '';
    } else {
      _message = vBench.message ?? PasarAjaConstant.unknownError;
    }

    // update button status
    _updateButonState();
  }

  void _updateButonState() {
    if (vName.status == null || vNoHp.status == null || vBench.status == null) {
      _buttonState = ActionButton.stateDisabledButton;
    }
    if (vName.status == false ||
        vNoHp.status == false ||
        vBench.status == false) {
      _buttonState = ActionButton.stateDisabledButton;
    } else {
      _buttonState = ActionButton.stateEnabledButton;
    }
    notifyListeners();
  }

  Future<void> photoPicker(ImageSource imageSource) async {
    // choose photo
    _photo = await PasarAjaUtils.pickPhoto(imageSource) as ChoosePhotoEntity;

    // jika user memilih foto
    if (_photo.imageSelected != null) {
      // crop foto
      final crop = await PasarAjaUtils.cropImage(
        _photo.imageSelected!,
      );
      // buka halaman update photo
      Get.to(
        CropPhotoShopPage(
          idShop: 1,
          imageFile: crop!,
        ),
        transition: Transition.cupertino,
      );
    }
  }

  Future<void> onButtonSavePressed() async {
    try {
      PasarAjaMessage.showLoading();

      final idShop = await PasarAjaUserService.getShopId();

      final dataState = await _controller.updateShopData(
        idShop: idShop,
        shopName: nameCont.text,
        benchmark: benchmarkCont.text,
        description: descCont.text,
        phone: noHpCont.text,
      );

      Get.back();

      if(dataState is DataSuccess){
        await PasarAjaMessage.showInformation('Data Toko Berhasil Diedit');
        Get.back();
      }

      if(dataState is DataFailed){
        await PasarAjaMessage.showSnackbarError(dataState.error.toString());
      }
    } catch (ex) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      await PasarAjaMessage.showSnackbarError(ex.toString());
    }
  }
}
