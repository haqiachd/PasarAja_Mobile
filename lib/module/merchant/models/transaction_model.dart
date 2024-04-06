import 'package:pasaraja_mobile/core/entities/transaction_entity.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_detail_model.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    final int? idTrx,
    final int? idUser,
    final String? orderCode,
    final String? orderPin,
    final String? status,
    final DateTime? takenDate,
    final int? expirationTime,
    final int? confirmedBy,
    final String? canceledMessage,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? fullName,
    final String? phoneNumber,
    final String? userPhoto,
    final List<TransactionDetailModel>? details,
  }) : super(
          idTrx: idTrx,
          idUser: idUser,
          orderCode: orderCode,
          orderPin: orderPin,
          status: status,
          takenDate: takenDate,
          expirationTime: expirationTime,
          confirmedBy: confirmedBy,
          canceledMessage: canceledMessage,
          createdAt: createdAt,
          updatedAt: updatedAt,
          fullName: fullName,
          phoneNumber: phoneNumber,
          userPhoto: userPhoto,
          details: details,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        idTrx: json["id_trx"],
        idUser: json["id_user"],
        orderCode: json["order_code"],
        orderPin: json["order_pin"],
        status: json["status"],
        takenDate: json["taken_date"] == null
            ? null
            : DateTime.parse(json["taken_date"]),
        expirationTime: json["expiration_time"],
        confirmedBy: json["confirmed_by"],
        canceledMessage: json["canceled_message"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        userPhoto: json["user_photo"],
        details: TransactionDetailModel.fromList(json['details']),
      );

  static List<TransactionModel> fromList(List<dynamic> json) {
    return json.map((e) => TransactionModel.fromJson(e)).toList();
  }
}
