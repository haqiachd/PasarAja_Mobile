import 'package:equatable/equatable.dart';

class ProductPromoEntity extends Equatable {
  final int? defaultPrice;
  final int? promoPrice;
  final DateTime? promoStart;
  final DateTime? promoEnd;

  const ProductPromoEntity({
    this.defaultPrice,
    this.promoPrice,
    this.promoStart,
    this.promoEnd,
  });

  @override
  List<Object?> get props {
    return [
      defaultPrice,
      promoPrice,
      promoStart,
      promoPrice,
    ];
  }
}