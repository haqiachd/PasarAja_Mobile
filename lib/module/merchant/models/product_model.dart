import 'dart:convert';

import 'package:pasaraja_mobile/core/entities/product_entity.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_settings_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    final int? idProduct,
    final int? idShop,
    final int? idCpProd,
    final String? categoryName,
    final String? productName,
    final String? description,
    final int? sellingUnit,
    final ProductSettingsModel? settings,
    final PromoModel? promo,
    final String? unit,
    final int? price,
    final int? totalSold,
    final num? rating,
    final int? totalReview,
    final String? photo,
    final DateTime? updatedAt,
  }) : super(
          id: idProduct,
          idShop: idShop,
          idCpProd: idCpProd,
          categoryName: categoryName,
          productName: productName,
          description: description,
          sellingUnit: sellingUnit,
          settings: settings,
          unit: unit,
          price: price,
          rating: rating,
          totalReview: totalReview,
          totalSold: totalSold,
          photo: photo,
          updatedAt: updatedAt,
          promo: promo,
        );

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      idProduct: map['id_product'] ?? 0,
      idShop: map['id_shop'] ?? 0,
      idCpProd: map['id_cp_prod'] ?? 0,
      categoryName: map['category_name'] ?? '',
      productName: map['product_name'] ?? '',
      description: map['description'] ?? '',
      sellingUnit: map['selling_unit'] ?? 0,
      settings: ProductSettingsModel.fromJson(jsonDecode(map['settings'])),
      unit: map['unit'] ?? '',
      price: map['price'] ?? 0,
      totalSold: map['total_sold'] ?? 0,
      photo: map['photo'] ?? '',
      rating: map['rating'] ?? 0.0,
      totalReview: map['total_review'] ?? 0,
      updatedAt: map["updated_at"] == null
          ? null
          : DateTime.parse(
              map["updated_at"],
            ),
      promo: map['promo'] != null
          ? PromoModel.fromJson(map['promo'])
          : const PromoModel(),
    );
  }

  static List<ProductModel> fromList(List<dynamic> payload) {
    return payload
        .map<ProductModel>(
            (dynamic i) => ProductModel.fromJson(i as Map<String, dynamic>))
        .toList();
  }
}
