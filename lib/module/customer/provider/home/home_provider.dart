import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/controllers/page_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/page/beranda_page_model.dart';

class HomeProvider extends ChangeNotifier{
  ProviderState state = const OnInitState();

  final _pageCont = CustomerPageController();

  String _photoProfile = '';
  String get photoProfile => _photoProfile;
  set photoProfile(String f){
    _photoProfile = f;
    notifyListeners();
  }

  BerandaModel _berandaModel = BerandaModel();
  BerandaModel get berandaModel => _berandaModel;

  Future<void> fetchData() async {
    try{
      state = const OnLoadingState();
      notifyListeners();

      _photoProfile = await PasarAjaUserService.getUserData(PasarAjaUserService.photo);

      final dataState = await _pageCont.homepage();

      if(dataState is DataSuccess){
        state = const OnSuccessState();
        _berandaModel = dataState.data as BerandaModel;
        notifyListeners();
      }

      notifyListeners();
    }catch(ex){
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}