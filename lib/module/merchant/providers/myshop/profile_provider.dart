import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/auth/controllers/auth_controller.dart';
import 'package:pasaraja_mobile/module/merchant/views/myshop/update_pp_page.dart';

class ProfileProvider extends ChangeNotifier {
  final _controller = AuthController();
  ProviderState state = const OnInitState();

  String _fullName = '';

  String get fullName => _fullName;

  String _email = '';

  String get email => _email;

  String _phoneNumber = '';

  String get phoneNumber => _phoneNumber;

  String _photoProfile = '';

  String get photoProfile => _photoProfile;

  // file photo product
  ChoosePhotoEntity _photo = const ChoosePhotoEntity(
    image: null,
    imageSelected: null,
  );

  Future<void> fetchData() async {
    try {
      // set loading
      state = const OnLoadingState();
      notifyListeners();

      // fetch data
      _fullName =
          await PasarAjaUserService.getUserData(PasarAjaUserService.fullName);
      _email = await PasarAjaUserService.getUserData(PasarAjaUserService.email);
      _phoneNumber =
          await PasarAjaUserService.getUserData(PasarAjaUserService.phone);
      _photoProfile =
          await PasarAjaUserService.getUserData(PasarAjaUserService.photo);

      state = const OnSuccessState();
      notifyListeners();
    } catch (ex) {
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }

  Future<void> photoPicker(ImageSource imageSource) async {
    // choose photo
    _photo = await PasarAjaUtils.pickPhoto(imageSource) as ChoosePhotoEntity;

    // jika user memilih foto
    if (_photo.imageSelected != null) {
      // crop foto
      final crop = await PasarAjaUtils.cropImage(
        _photo.imageSelected!,
        cropStyle: CropStyle.circle,
      );
      // buka halaman update photo
      Get.to(
        UpdatePhotoProfilePage(email: _email, imageFile: crop!),
        transition: Transition.cupertino,
      );
    }
  }

  Future<void> deletePhoto() async {
    // konfirmasi hapus foto
    final confirm = await PasarAjaMessage.showConfirmation(
      "Apakah Anda Yakin Ingin Menghapus Foto Profile",
    );

    if (!confirm) {
      return;
    }

    PasarAjaMessage.showLoading();

    DMethod.log('prepare controller');
    final dataState = await _controller.deletePhotoProfile(
      email: _email,
    );

    if (dataState is DataSuccess) {
      DMethod.log('data success');
      Get.back();
      await PasarAjaMessage.showInformation(
        'Foto Profile Berhasil Dihapus',
      );


      DMethod.log('save pref');
      // simpan default photo
      String photo = dataState.data as String;
      await PasarAjaUserService.setUserData(
        PasarAjaUserService.photo,
        photo,
      );

      DMethod.log('fetch ulang');
      // reload ulang data
      await fetchData();
    }

    if (dataState is DataFailed) {
      DMethod.log('data failed : ${dataState.error?.error.toString() ?? PasarAjaConstant.unknownError}');
      Get.back();
      await PasarAjaMessage.showSnackbarWarning(
        dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
      );
    }
  }
}
