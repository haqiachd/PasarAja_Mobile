import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';

class UpdatePhotoProfileProvider extends ChangeNotifier {
  final _controller = AuthController();

  String _email = '';

  String get email => _email;

  set email(String i) {
    _email = i;
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
      final crop = await PasarAjaUtils.cropImage(photoEntity.imageSelected!,
          cropStyle: CropStyle.circle);
      // update image crop
      _imageFile = crop!;
      notifyListeners();
    }
  }

  Future<void> updatePhoto() async {
    PasarAjaMessage.showLoading();

    if (_imageFile.existsSync()) {
      DMethod.log("step 1");
      // cek jika ukuran gambar > 512
      double fileSizeInBytes = _imageFile.lengthSync() / 1024;

      if (fileSizeInBytes > 512) {
        DMethod.log("step 2");
        // compress gambar
        final imgCompress = await PasarAjaUtils.compressImage(_imageFile);
        // jika compress berhasil
        if (imgCompress != null) {
          DMethod.log("step 3");
          _imageFile = imgCompress;
          double afterCompress = _imageFile.lengthSync() / 1024;
          // cek apakah file hasil compress sizenya masih > 512
          if (afterCompress > 512) {
            DMethod.log('compress ulang');
          }
        }
      }
    }

    // call controller
    final dataState = await _controller.updatePhotoProfile(
      email: _email,
      newPhoto: _imageFile,
    );

    // jika foto profile barhasil diupdate
    if (dataState is DataSuccess) {
      Get.back();
      String newPath = dataState.data as String;
      // update preferences
      await PasarAjaUserService.setUserData(PasarAjaUserService.photo, newPath);

      // show success info
      await PasarAjaMessage.showInformation(
        'Foto Profil Berhasil Diupdate',
      );

      Get.back();
    }

    // jika foto profile gagal diupdate
    if (dataState is DataFailed) {
      Get.back();
      PasarAjaMessage.showSnackbarWarning(
        dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
      );
    }
  }
}
