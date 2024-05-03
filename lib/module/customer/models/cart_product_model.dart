import 'dart:convert';

import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class CartProductModel {
  final int? idProduct;
  int? quantity;
  final int? promoPrice;
  final String? notes;
  final ProductModel? productData;
  bool checked;

  CartProductModel({
    this.idProduct,
    this.quantity,
    this.promoPrice,
    this.notes,
    this.productData,
    this.checked = false,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) =>
      CartProductModel(
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
