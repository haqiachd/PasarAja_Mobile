import 'package:equatable/equatable.dart';

class TransactionDetailEntity extends Equatable {
  final int? idProduct;
  final int? quantity;
  final String? productName;
  final String? productPhoto;
  final String? unit;
  final int? sellingUnit;
  final int? price;
  final int? promoPrice;
  final int? totalPrice;
  final String? notes;

  const TransactionDetailEntity({
    this.idProduct,
    this.quantity,
    this.productName,
    this.productPhoto,
    this.unit,
    this.sellingUnit,
    this.price,
    this.promoPrice,
    this.totalPrice,
    this.notes,
  });

  @override
  List<Object?> get props {
    return [
      idProduct,
      quantity,
      productName,
      productPhoto,
      unit,
      sellingUnit,
      price,
      promoPrice,
      totalPrice,
      notes,
    ];
  }
}
