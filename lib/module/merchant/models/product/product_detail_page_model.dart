import 'dart:convert';

import 'package:pasaraja_mobile/module/merchant/models/complain_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_histories_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_settings_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/review_model.dart';

class ProductDetailModel {
  final int? idProduct;
  final int? idShop;
  final int? idCpProd;
  final String? categoryName;
  final String? productName;
  final String? description;
  final int? totalSold;
  final ProductSettingsModel? settings;
  final String? unit;
  final int? sellingUnit;
  final int? price;
  final String? photo;
  final num? rating;
  final int? totalReview;
  final List<ReviewModel>? reviews;
  final List<ComplainModel>? complains;
  final List<ProductHistoriesModel>? histories;

  ProductDetailModel({
    this.idProduct,
    this.idShop,
    this.idCpProd,
    this.categoryName,
    this.productName,
    this.description,
    this.totalSold,
    this.settings,
    this.unit,
    this.sellingUnit,
    this.price,
    this.photo,
    this.rating,
    this.totalReview,
    this.reviews,
    this.complains,
    this.histories,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> map) {
    return ProductDetailModel(
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
      rating: map['rating'],
      totalReview: map['total_review'],
      reviews: ReviewModel.fromList(map['reviews']),
      complains: ComplainModel.fromList(map['complains']),
      histories: ProductHistoriesModel.fromList(map['histories']),
    );
  }
}
