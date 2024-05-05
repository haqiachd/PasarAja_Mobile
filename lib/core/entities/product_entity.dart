import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/product_settings_entity.dart';
import 'package:pasaraja_mobile/core/entities/promo_entity.dart';

class ProductEntity extends Equatable {
  final int? id;
  final int? idShop;
  final int? idCpProd;
  final String? categoryName;
  final String? productName;
  final String? description;
  final int? totalSold;
  final ProductSettingsEntity? settings;
  final PromoEntity? promo;
  final String? unit;
  final int? sellingUnit;
  final int? price;
  final String? photo;
  final num? rating;
  final int? totalReview;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    this.id,
    this.idShop,
    this.idCpProd,
    this.categoryName,
    this.productName,
    this.description,
    this.totalSold,
    this.settings,
    this.unit,
    this.promo,
    this.sellingUnit,
    this.price,
    this.photo,
    this.rating,
    this.totalReview,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      idShop,
      idCpProd,
      categoryName,
      productName,
      promo,
      description,
      totalSold,
      settings,
      unit,
      sellingUnit,
      price,
      photo,
      rating,
      totalReview,
      createdAt,
      updatedAt,
    ];
  }
}
