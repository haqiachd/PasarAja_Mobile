import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/myshop_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/operational_model.dart';

class EditOperationalProvider extends ChangeNotifier {
  final _controller = MyShopController();

  ProviderState state = const OnInitState();

  bool _monday = false;
  bool get monday => _monday;
  set monday(bool s) {
    _monday = s;
    notifyListeners();
  }

  bool _tuesday = false;
  bool get tuesday => _tuesday;
  set tuesday(bool s) {
    _tuesday = s;
    notifyListeners();
  }

  bool _wednesday = false;
  bool get wednesday => _wednesday;
  set wednesday(bool s) {
    _wednesday = s;
    notifyListeners();
  }

  bool _thursday = false;
  bool get thursday => _thursday;
  set thursday(bool s) {
    _thursday = s;
    notifyListeners();
  }

  bool _friday = false;
  bool get friday => _friday;
  set friday(bool s) {
    _friday = s;
    notifyListeners();
  }

  bool _saturday = false;
  bool get saturday => _saturday;
  set saturday(bool s) {
    _saturday = s;
    notifyListeners();
  }

  bool _sunday = false;
  bool get sunday => _sunday;
  set sunday(bool s) {
    _sunday = s;
    notifyListeners();
  }

  Future<void> init() async {
    try{
      state = const OnLoadingState();
      notifyListeners();

      final idShop = await PasarAjaUserService.getShopId();

      final dataState = await _controller.getOperational(
        idShop: idShop,
      );

      if (dataState is DataSuccess) {

        state = const OnSuccessState();
        notifyListeners();

        var jam = dataState.data as OperationalModel;

        _monday = jam.senin ?? false;
        _tuesday = jam.selasa ?? false;
        _wednesday = jam.rabu ?? false;
        _thursday = jam.kamis ?? false;
        _friday = jam.jumat ?? false;
        _saturday = jam.sabtu ?? false;
        _sunday = jam.minggu ?? false;
        notifyListeners();
      }

      if (dataState is DataFailed) {
        state = OnFailureState(
          dioException: dataState.error,
        );
        notifyListeners();
      }
    }catch(ex){
      state = OnFailureState(
        message: ex.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> onSaveButton() async {
    try {
      //
      var jamBuka = OperationalModel(
        senin: _monday,
        selasa: _tuesday,
        rabu: _wednesday,
        kamis: _thursday,
        jumat: _friday,
        sabtu: _saturday,
        minggu: _sunday,
      );

      await PasarAjaMessage.showLoading();

      final idShop = await PasarAjaUserService.getShopId();

      final dataState = await _controller.updateOperational(
        idShop: idShop,
        operational: jamBuka,
      );

      Get.back();

      if (dataState is DataSuccess) {
        await PasarAjaMessage.showInformation('Jam Buka Toko Berhasil Diedit');
      }

      if (dataState is DataFailed) {
        await PasarAjaMessage.showSnackbarWarning(
          dataState.error?.error?.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      await PasarAjaMessage.showSnackbarWarning('Error : $ex');
    }
  }
}
