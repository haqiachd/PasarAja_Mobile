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
import 'package:pasaraja_mobile/module/merchant/controllers/product_controller.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/add_product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/add_product_page.dart';

class CropPhotoProvider extends ChangeNotifier {
  final _controller = ProductController();

  int _idProduct = 0;

  int get idProduct => _idProduct;

  set idProduct(int i) {
    _idProduct = i;
    notifyListeners();
  }

  int _idCategory = 0;

  int get idCategory => _idCategory;

  set idCategory(int i) {
    _idCategory = i;
    notifyListeners();
  }

  String _categoryName = '';

  String get categoryName => _categoryName;

  set categoryName(String i) {
    _categoryName = i;
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
      final dataState = await _controller.updatePhoto(
        idShop: idShop,
        idProduct: idProduct,
        photo: _imageFile,
      );

      Get.back();

      // jika foto berhasil diupdate
      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation("Foto Produk Berhasil Diupdate");
        Get.back();
        Get.back();
        Get.back();
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

  Future<void> justCropPhoto() async {
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

      // save photo ke entity
      final photoEntity = ChoosePhotoEntity(
        image: _imageFile.readAsBytesSync(),
        imageSelected: _imageFile,
      );

      Get.back();

      // kembali ke add product
      Get.to(
        AddProductPage(
          idCategory: _idCategory,
          categoryName: _categoryName,
          photoEntity: photoEntity,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }
}
