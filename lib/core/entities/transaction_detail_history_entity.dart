import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/product_entity.dart';

class TransactionDetailHistoryEntity extends Equatable {
  final int? price;
  final int? quantity;
  final int? promoPrice;
  final int? totalPrice;
  final int? subTotal;
  final String? notes;
  final String? unit;
  final int? sellingUnit;
  final ProductEntity? product;

  const TransactionDetailHistoryEntity({
    this.price,
    this.quantity,
    this.promoPrice,
    this.totalPrice,
    this.subTotal,
    this.notes,
    this.unit,
    this.sellingUnit,
    this.product,
  });

  @override
  List<Object?> get props {
    return [
      price,
      quantity,
      promoPrice,
      totalPrice,
      totalPrice,
      subTotal,
      notes,
      unit,
      sellingUnit,
      product,
    ];
  }
}
