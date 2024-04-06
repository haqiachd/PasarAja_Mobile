import 'package:equatable/equatable.dart';
import 'package:pasaraja_mobile/core/entities/transaction_detail_entity.dart';

class TransactionEntity extends Equatable {
  final int? idTrx;
  final int? idUser;
  final String? orderCode;
  final String? orderPin;
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
  final List<TransactionDetailEntity>? details;

  const TransactionEntity({
    this.idTrx,
    this.idUser,
    this.orderCode,
    this.orderPin,
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
  });

  @override
  List<Object?> get props {
    return [
      idTrx,
      idUser,
      orderCode,
      orderPin,
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
    ];
  }
}
