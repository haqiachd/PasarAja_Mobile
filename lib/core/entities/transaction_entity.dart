import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/shop_entity.dart';
import 'package:pasaraja_mobile/core/entities/transaction_detail_entity.dart';
import 'package:pasaraja_mobile/core/entities/user_entity.dart';

class TransactionEntity extends Equatable {
  final int? idTrx;
  final int? idUser;
  final String? orderCode;
  final String? orderPin;
  final String? orderId;
  final String? status;
  final DateTime? takenDate;
  final int? expirationTime;
  final int? confirmedBy;
  final String? canceledMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? fullName;
  final String? phoneNumber;
  final String? userPhoto;
  final int? totalProduct;
  final int? totalQuantity;
  final int? totalPromo;
  final int? subTotal;
  final int? totalPrice;
  final List<TransactionDetailEntity>? details;
  final ShopEntity? shopData;
  final UserEntity? userData;

  const TransactionEntity({
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
    this.fullName,
    this.phoneNumber,
    this.userPhoto,
    this.details,
    this.totalProduct,
    this.totalQuantity,
    this.totalPromo,
    this.subTotal,
    this.totalPrice,
    this.shopData,
    this.userData,
  });

  @override
  List<Object?> get props {
    return [
      idTrx,
      idUser,
      orderCode,
      orderPin,
      orderId,
      status,
      takenDate,
      expirationTime,
      confirmedBy,
      canceledMessage,
      createdAt,
      updatedAt,
      fullName,
      phoneNumber,
      userPhoto,
      details,
      totalProduct,
      totalQuantity,
      totalPromo,
      subTotal,
      totalPrice,
      shopData,
      userData,
    ];
  }
}
