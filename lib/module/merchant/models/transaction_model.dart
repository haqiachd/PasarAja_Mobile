import 'package:pasaraja_mobile/core/entities/transaction_entity.dart';
import 'package:pasaraja_mobile/module/merchant/models/order/shop_data_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/order/user_data_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_detail_model.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    final int? idTrx,
    final int? idUser,
    final String? orderCode,
    final String? orderPin,
    final String? orderId,
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
    final int? totalProduct,
    final int? totalQuantity,
    final int? totalPromo,
    final int? subTotal,
    final int? totalPrice,
    final List<TransactionDetailModel>? details,
    final ShopDataModel? shopData,
    final UserDataModel? userData,
  }) : super(
          idTrx: idTrx,
          idUser: idUser,
          orderCode: orderCode,
          orderPin: orderPin,
          orderId: orderId,
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
          totalProduct: totalProduct,
          totalQuantity: totalQuantity,
          totalPromo: totalPromo,
          subTotal: subTotal,
          totalPrice: totalPrice,
          details: details,
          shopData: shopData,
          userData: userData,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        idTrx: json["id_trx"] ?? 0,
        idUser: json["id_user"] ?? 0,
        orderCode: json["order_code"] ?? '',
        orderPin: json["order_pin"] ?? '',
        orderId: json['order_id'] ?? '',
        status: json["status"] ?? '',
        takenDate: json["taken_date"] == null
            ? null
            : DateTime.parse(json["taken_date"]),
        expirationTime: json["expiration_time"] ?? 0,
        confirmedBy: json["confirmed_by"] ?? '',
        canceledMessage: json["canceled_message"] ?? '',
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        fullName: json["full_name"] ?? '',
        phoneNumber: json["phone_number"] ?? '',
        userPhoto: json["user_photo"] ?? '',
        details: TransactionDetailModel.fromList(json['details']),
        totalProduct: json['total_product'] ?? 0,
        totalQuantity: json['total_quantity'] ?? 0,
        totalPromo: json['total_promo'] ?? 0,
        subTotal: json['sub_total'] ?? 0,
        totalPrice: json['total_price'] ?? 0,
        shopData: json['shop_data'] == null
            ? const ShopDataModel()
            : ShopDataModel.fromJson(json['shop_data']),
        userData: json['user_data'] == null
            ? const UserDataModel()
            : UserDataModel.fromJson(json['user_data']),
      );

  static List<TransactionModel> fromList(List<dynamic> json) {
    return json.map((e) => TransactionModel.fromJson(e)).toList();
  }
}
