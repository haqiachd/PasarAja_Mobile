import 'package:pasaraja_mobile/core/entities/transaction_history_entity.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';

class TransactionHistoryModel extends TransactionHistoryEntity {
  const TransactionHistoryModel({
    final int? idTrx,
    final String? orderId,
    final String? orderCode,
    final String? orderPin,
    final int? idUser,
    final String? status,
    final DateTime? takenDate,
    final String? canceledMessage,
    final int? confirmedBy,
    final int? totalProduct,
    final int? totalQuantity,
    final int? totalPromo,
    final int? subTotal,
    final int? totalPrice,
    final int? expirationTime,
    final ShopDataModel? shopData,
    final List<TransactionDetailHistoryModel>? details,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) : super(
          idTrx: idTrx,
          orderId: orderId,
          orderPin: orderPin,
          orderCode: orderCode,
          idUser: idUser,
          status: status,
          takenDate: takenDate,
          canceledMessage: canceledMessage,
          confirmedBy: confirmedBy,
          totalProduct: totalProduct,
          totalQuantity: totalQuantity,
          totalPromo: totalPromo,
          subTotal: subTotal,
          totalPrice: totalPrice,
          expirationTime: expirationTime,
          shopData: shopData,
          details: details,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
        idTrx: json["id_trx"] ?? 0,
        orderId: json['order_id'] ?? '',
        orderCode: json["order_code"] ?? '',
        orderPin: json["order_pin"] ?? '',
        idUser: json["id_user"] ?? 0,
        status: json["status"] ?? '',
        takenDate: json["taken_date"] == null
            ? null
            : DateTime.parse(json["taken_date"]),
        canceledMessage: json["canceled_message"] ?? '',
        confirmedBy: json["confirmed_by"] ?? '',
        totalProduct: json['total_product'] ?? 0,
        totalQuantity: json['total_quantity'] ?? 0,
        subTotal: json['sub_total'] ?? 0,
        totalPromo: json['total_promo'] ?? 0,
        totalPrice: json['total_price'] ?? 0,
        expirationTime: json["expiration_time"] ?? 0,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        shopData: json['shop_data'] == null
            ? const ShopDataModel()
            : ShopDataModel.fromJson(json['shop_data']),
        details: json['details']
            ? []
            : TransactionDetailHistoryModel.toList(json['details']),
      );

  static List<TransactionHistoryModel> toList(List<dynamic> json) =>
      json.map((e) => TransactionHistoryModel.fromJson(e)).toList();
}
