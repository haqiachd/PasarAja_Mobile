import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';

class MyShopProvider extends ChangeNotifier{
  ProviderState state = const OnInitState();

  String _photoProfile = '';
  String get photoProfile => _photoProfile;
  set photoProfile(String f){
    _photoProfile = f;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try{
      state = const OnLoadingState();
      notifyListeners();

      _photoProfile = await PasarAjaUserService.getUserData(PasarAjaUserService.photo);

      notifyListeners();
    }catch(ex){
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}
