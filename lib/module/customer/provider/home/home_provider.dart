import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/controllers/page_controller.dart';
import 'package:pasaraja_mobile/module/customer/models/page/beranda_page_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class HomeProvider extends ChangeNotifier{
  ProviderState state = const OnInitState();

  final _pageCont = CustomerPageController();

  String _photoProfile = '';
  String get photoProfile => _photoProfile;
  set photoProfile(String f){
    _photoProfile = f;
    notifyListeners();
  }

  BerandaModel _berandaModel = const BerandaModel();
  BerandaModel get berandaModel => _berandaModel;

  List<ProductModel> allProducts = [];
  List<ProductModel> recommendedProduct = [];
  List<ProductModel> bestRating = [];
  List<ProductModel> bestSelling = [];

  Future<void> fetchData() async {
    allProducts = [];
    recommendedProduct = [];
    bestRating = [];
    bestSelling = [];
    notifyListeners();
    try{
      state = const OnLoadingState();
      notifyListeners();

      _photoProfile = await PasarAjaUserService.getUserData(PasarAjaUserService.photo);

      final dataState = await _pageCont.homepage();

      if(dataState is DataSuccess){
        state = const OnSuccessState();
        _berandaModel = dataState.data as BerandaModel;

        for (var prod in _berandaModel.products!) {
          if ((prod.settings?.isAvailable ?? false) == true &&
              (prod.settings?.isShown ?? false)) {
            if(!allProducts.contains(prod)){
              allProducts.add(prod);
            }
          }

          if(prod.settings?.isRecommended ?? false){
            recommendedProduct.add(prod);
          }
        }

        recommendedProduct = PasarAjaUtils.shuffleList(recommendedProduct);
        recommendedProduct = recommendedProduct.length >= 7 ? recommendedProduct.getRange(0, 7).toList() : bestSelling;

        bestSelling = allProducts.sorted((a, b) => b.totalSold!.compareTo(a.totalSold!));
        bestSelling = bestSelling.length >= 7 ? bestSelling.getRange(0, 7).toList() : bestSelling;

        bestRating = allProducts.sorted((a, b) => b.rating!.compareTo(a.rating!));
        bestRating = bestRating.length >= 7 ? bestRating.getRange(0, 7).toList() : bestRating;

        notifyListeners();
      }

      notifyListeners();
    }catch(ex){
      state = OnFailureState(message: ex.toString());
      notifyListeners();
    }
  }
}