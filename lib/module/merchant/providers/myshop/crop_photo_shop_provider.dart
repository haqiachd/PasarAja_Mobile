import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/myshop_controller.dart';

class CropPhotoShopProvider extends ChangeNotifier {
  final _controller = MyShopController();

  int _idShop = 0;
  int get idShop => _idShop;
  set idShop(int i) {
    _idShop = i;
    notifyListeners();
  }

  File _imageFile = File(PasarAjaImage.pasaraja);
  File get imageFile => _imageFile;
  set imageFile(File f) {
    _imageFile = f;
    notifyListeners();
  }

  Future<void> photoPicker(ImageSource imageSource) async {
    // choose photo
    final photoEntity =
    await PasarAjaUtils.pickPhoto(imageSource) as ChoosePhotoEntity;

    // jika user memilih foto
    if (photoEntity.imageSelected != null) {
      // crop foto
      final crop = await PasarAjaUtils.cropImage(
        photoEntity.imageSelected!,
      );
      // update image crop
      _imageFile = crop!;
      notifyListeners();
    }
  }

  Future<void> uploadProduct() async {
    PasarAjaMessage.showLoading();

    if (_imageFile.existsSync()) {
      // cek jika ukuran gambar > 512
      double fileSizeInBytes = _imageFile.lengthSync() / 1024;

      if (fileSizeInBytes > 512) {
        // compress gambar

        final imgCompress = await PasarAjaUtils.compressImage(_imageFile);
        // jika compress berhasil
        if (imgCompress != null) {
          _imageFile = imgCompress;
          double afterCompress = _imageFile.lengthSync() / 1024;
          // cek apakah file hasil compress sizenya masih > 512
          if (afterCompress > 512) {
            DMethod.log('compress ulang');
            uploadProduct();
          }
        }
      }

      // get id shop
      final idShop = await PasarAjaUserService.getShopId();

      // update foto produk
      final dataState = await _controller.updateShopPhoto(
        idShop: idShop,
        photo: _imageFile,
      );

      Get.back();

      // jika foto berhasil diupdate
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Foto Toko Berhasil Diupdate");
        Get.back();
        Get.back();
        // Get.back();
      }

      // jika foto gagal diupdate
      if (dataState is DataFailed) {
        await PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } else {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

}
