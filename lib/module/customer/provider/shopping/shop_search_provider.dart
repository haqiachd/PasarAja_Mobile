import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class ShopSearchProvider extends ChangeNotifier{

  List<ShopDataModel> _shops = [];
  List<ShopDataModel> get shops => _shops;
  set shops(List<ShopDataModel> p){
    _shops = p;
    _shopFil = [];
    cariShop.text = '';
    notifyListeners();
  }

  List<ShopDataModel> _shopFil = [];
  List<ShopDataModel> get shopFil => _shopFil;

  TextEditingController cariShop = TextEditingController(text: '');

  void cari(){
    if(cariShop.text.trim().isEmpty){
      _shopFil = [];
      notifyListeners();
      return;
    }
    _shopFil = shops
        .where((element) => element.shopName?.toLowerCase().contains(cariShop.text.toLowerCase()) ?? false)
        .toList();
    notifyListeners();
  }
}