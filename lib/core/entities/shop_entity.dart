import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/operational_entity.dart';

class ShopEntity extends Equatable {
  final int? idShop;
  final int? idUser;
  final String? phoneNumber;
  final String? shopName;
  final String? description;
  final String? benchmark;
  final OperationalEntity? operational;
  final String? photo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? ownerName;
  final int? totalProduct;
  final int? totalSold;
  final int? totalPromo;
  final int? totalTransaction;
  final int? totalReview;
  final num? totalRating;
  final int? totalComplain;

  const ShopEntity({
    this.idShop,
    this.idUser,
    this.phoneNumber,
    this.shopName,
    this.description,
    this.benchmark,
    this.operational,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.ownerName,
    this.totalProduct,
    this.totalSold,
    this.totalPromo,
    this.totalTransaction,
    this.totalRating,
    this.totalReview,
    this.totalComplain,
  });

  @override
  List<Object?> get props {
    return [
      idShop,
      idUser,
      phoneNumber,
      shopName,
      description,
      benchmark,
      operational,
      photo,
      createdAt,
      updatedAt,
      ownerName,
      totalProduct,
      totalSold,
      totalPromo,
      totalTransaction,
      totalRating,
      totalReview,
      totalComplain,
    ];
  }
}
