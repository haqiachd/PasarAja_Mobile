import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/core/utils/parsing.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class CartProductModel {
  final int? idCart;
  final int? idProduct;
  int? quantity;
  final int? promoPrice;
  String? notes;
  final ProductModel? productData;
  bool checked;
  bool onChages;
  TextEditingController? controller;
  int? totalPrice;

  CartProductModel({
    this.idCart,
    this.idProduct,
    this.quantity,
    this.promoPrice,
    this.notes,
    this.productData,
    this.checked = false,
    this.onChages = false,
    this.controller,
    this.totalPrice,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) =>
      CartProductModel(
        idCart:  PasarAjaParsing.tryInt(json['id_cart']),
        idProduct:  PasarAjaParsing.tryInt(json["id_product"]),
        quantity: PasarAjaParsing.tryInt(json["quantity"]),
        promoPrice:  PasarAjaParsing.tryInt(json["promo_price"]),
        notes: json["notes"] ?? '',
        productData: ProductModel.fromJson(
          json['product_data'],
        ),
      );

  static List<CartProductModel> fromList(List<dynamic> json) =>
      json.map((e) => CartProductModel.fromJson(e)).toList();
}
