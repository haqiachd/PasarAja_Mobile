import 'package:equatable/equatable.dart';

class PromoEntity extends Equatable {
  final int? idPromo;
  final int? idCpProd;
  final int? idShop;
  final int? idProduct;
  final String? productName;
  final int? price;
  final int? promoPrice;
  final num? percentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? photo;

  const PromoEntity({
    this.idPromo,
    this.idCpProd,
    this.idShop,
    this.idProduct,
    this.productName,
    this.price,
    this.promoPrice,
    this.percentage,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.photo,
  });

  @override
  List<Object?> get props {
    return [
      idPromo,
      idCpProd,
      idShop,
      idProduct,
      price,
      promoPrice,
      percentage,
      startDate,
      endDate,
      createdAt,
      updatedAt,
      photo,
    ];
  }
}
