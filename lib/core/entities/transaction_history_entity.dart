import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/shop_entity.dart';
import 'package:pasaraja_mobile/core/entities/transaction_detail_history_entity.dart';

class TransactionHistoryEntity extends Equatable {
  final int? idTrx;
  final String? orderId;
  final String? orderCode;
  final String? orderPin;
  final int? idUser;
  final String? status;
  final DateTime? takenDate;
  final String? canceledMessage;
  final int? confirmedBy;
  final int? totalProduct;
  final int? totalQuantity;
  final int? totalPromo;
  final int? subTotal;
  final int? totalPrice;
  final int? expirationTime;
  final ShopEntity? shopData;
  final List<TransactionDetailHistoryEntity>? details;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TransactionHistoryEntity({
    this.idTrx,
    this.idUser,
    this.orderCode,
    this.orderPin,
    this.orderId,
    this.status,
    this.takenDate,
    this.expirationTime,
    this.confirmedBy,
    this.canceledMessage,
    this.createdAt,
    this.updatedAt,
    this.totalProduct,
    this.totalQuantity,
    this.totalPromo,
    this.subTotal,
    this.totalPrice,
    this.shopData,
    this.details,
  });

  @override
  List<Object?> get props {
    return [
      idTrx,
      idUser,
      orderCode,
      orderId,
      orderPin,
      status,
      takenDate,
      expirationTime,
      confirmedBy,
      canceledMessage,
      createdAt,
      updatedAt,
      totalProduct,
      totalPromo,
      subTotal,
      totalPrice,
      shopData,
      details,
    ];
  }
}
