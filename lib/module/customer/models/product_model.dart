import 'dart:convert';

import 'package:pasaraja_mobile/core/entities/product_entity.dart';
import 'package:pasaraja_mobile/core/utils/parsing.dart';
import 'package:pasaraja_mobile/module/customer/models/product_settings_model.dart';
import 'package:pasaraja_mobile/module/customer/models/promo_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    final int? idProduct,
    final int? idShop,
    final int? idCpProd,
    final String? categoryName,
    final String? productName,
    final String? description,
    final int? totalSold,
    final ProductSettingsModel? settings,
    final PromoModel? promo,
    final String? unit,
    final int? sellingUnit,
    final int? price,
    final String? photo,
    final num? rating,
    final int? totalReview,
  }) : super(
          id: idProduct,
          idShop: idShop,
          idCpProd: idCpProd,
          categoryName: categoryName,
          productName: productName,
          description: description,
          settings: settings,
          unit: unit,
          sellingUnit: sellingUnit,
          price: price,
          photo: photo,
          totalSold: totalSold,
          totalReview: totalReview,
          rating: rating,
          promo: promo,
        );

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      idProduct:  PasarAjaParsing.tryInt(map['id_product']),
      idShop:  PasarAjaParsing.tryInt(map['id_shop']),
      idCpProd:  PasarAjaParsing.tryInt(map['id_cp_prod']),
      categoryName: map['category_name'] ?? '',
      productName: map['product_name'] ?? '',
      description: map['description'] ?? '',
      sellingUnit:  PasarAjaParsing.tryInt(map['selling_unit']),
      settings: map['settings'] != null
          ? map['settings'] is Map<String, dynamic>
              ? ProductSettingsModel.fromJson(map['settings'])
              : ProductSettingsModel.fromJson(jsonDecode(map['settings']))
          : const ProductSettingsModel(),
      unit: map['unit'] ?? '',
      price:  PasarAjaParsing.tryInt(map['price']),
      totalSold:  PasarAjaParsing.tryInt(map['total_sold']),
      photo: map['photo'] ?? '',
      rating:  PasarAjaParsing.tryDouble(map['rating']),
      totalReview: PasarAjaParsing.tryInt(map['total_review']),
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

  Map<String, dynamic> toJson() {
    return {
      'id_product': id,
      'id_shop': idShop,
      'id_cp_prod': idCpProd,
      'category_name': categoryName,
      'product_name': productName,
      'description': description,
      'total_sold': totalSold,
      'unit': unit,
      'selling_unit': sellingUnit,
      'price': price,
      'photo': photo,
      'rating': rating,
      'total_review': totalReview,
      'promo': {
        "promo_price": promo?.promoPrice ?? 0,
        "percentage": promo?.percentage ?? 0,
        "start_date": promo?.startDate?.toIso8601String(),
        "end_date": promo?.endDate?.toIso8601String(),
      },
    };
  }
}
