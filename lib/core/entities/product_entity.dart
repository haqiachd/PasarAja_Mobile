import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/product_promo_entity.dart';
import 'package:pasaraja_mobile/core/entities/product_settings_entity.dart';

class ProductEntity extends Equatable {
  final int? id;
  final int? idShop;
  final int? idCpShop;
  final String? productName;
  final String? description;
  final int? totalSold;
  final ProductSettingsEntity? settings;
  final String? unit;
  final int? sellingUnit;
  final int? price;
  final ProductPromoEntity? promos;
  final String? photo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    this.id,
    this.idShop,
    this.idCpShop,
    this.productName,
    this.description,
    this.totalSold,
    this.settings,
    this.unit,
    this.sellingUnit,
    this.price,
    this.promos,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      idShop,
      idCpShop,
      productName,
      description,
      totalSold,
      settings,
      unit,
      sellingUnit,
      price,
      promos,
      photo,
      createdAt,
      updatedAt,
    ];
  }
}
