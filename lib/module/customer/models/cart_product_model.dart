import 'dart:convert';

import 'package:flutter/material.dart';
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
        idCart: json['id_cart'] ?? 0,
        idProduct: json["id_product"] ?? 0,
        quantity: json["quantity"] ?? 0,
        promoPrice: json["promo_price"] ?? 0,
        notes: json["notes"] ?? '',
        productData: ProductModel.fromJson(
          json['product_data'],
        ),
      );

  static List<CartProductModel> fromList(List<dynamic> json) =>
      json.map((e) => CartProductModel.fromJson(e)).toList();
}
