import 'package:equatable/equatable.dart';

class PromoEntity extends Equatable {
  final int? idPromo;
  final int? idShop;
  final int? idProduct;
  final int? defaultPrice;
  final int? promoPrice;
  final DateTime? promoStart;
  final DateTime? promoEnd;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PromoEntity({
    this.idPromo,
    this.idShop,
    this.idProduct,
    this.defaultPrice,
    this.promoPrice,
    this.promoStart,
    this.promoEnd,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      idPromo,
      idShop,
      idProduct,
      defaultPrice,
      promoPrice,
      promoStart,
      promoPrice,
      createdAt,
      updatedAt,
    ];
  }
}
