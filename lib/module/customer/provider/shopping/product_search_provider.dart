import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class ProductSearchProvider extends ChangeNotifier{

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;
  set products(List<ProductModel> p){
    cariProd.text = '';
    _productsFil = [];
    _products = p;
    notifyListeners();
  }

  List<ProductModel> _productsFil = [];
  List<ProductModel> get productsFil => _productsFil;

  TextEditingController cariProd = TextEditingController(text: ' ');

  void cari(){
    if(cariProd.text.trim().isEmpty){
      _productsFil = [];
      notifyListeners();
      return;
    }
    _productsFil = products
        .where((element) => element.productName?.toLowerCase().contains(cariProd.text.toLowerCase()) ?? false)
        .toList();
    notifyListeners();
  }

}