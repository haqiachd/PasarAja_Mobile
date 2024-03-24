import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/product_settings_entity.dart';

class ProductEntity extends Equatable {
  final int? id;
  final int? idShop;
  final int? idCpProd;
  final String? productName;
  final String? description;
  final int? totalSold;
  final ProductSettingsEntity? settings;
  final String? unit;
  final int? sellingUnit;
  final int? price;
  final String? photo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    this.id,
    this.idShop,
    this.idCpProd,
    this.productName,
    this.description,
    this.totalSold,
    this.settings,
    this.unit,
    this.sellingUnit,
    this.price,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      idShop,
      idCpProd,
      productName,
      description,
      totalSold,
      settings,
      unit,
      sellingUnit,
      price,
      photo,
      createdAt,
      updatedAt,
    ];
  }
}
