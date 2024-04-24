import 'package:pasaraja_mobile/core/entities/transaction_detail_history_entity.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

class TransactionDetailHistoryModel extends TransactionDetailHistoryEntity {
  const TransactionDetailHistoryModel({
    final int? price,
    final int? quantity,
    final int? promoPrice,
    final int? totalPrice,
    final int? subTotal,
    final String? notes,
    final String? unit,
    final int? sellingUnit,
    final ProductModel? product,
  }) : super(
          price: price,
          quantity: quantity,
          promoPrice: promoPrice,
          totalPrice: totalPrice,
          subTotal: subTotal,
          notes: notes,
          unit: unit,
          sellingUnit: sellingUnit,
          product: product,
        );

  factory TransactionDetailHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionDetailHistoryModel(
        unit: json["unit"] ?? '',
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
        quantity: json["quantity"] ?? 0,
        notes: json["notes"] ?? '',
        totalPrice: json["total_price"] ?? 0,
        price: json["price"] ?? 0,
        promoPrice: json["promo_price"] ?? 0,
        subTotal: json["sub_total"] ?? 0,
        sellingUnit: json["selling_unit"] ?? 0,
      );

  static List<TransactionDetailHistoryModel> toList(List<dynamic> json) =>
      json.map((e) => TransactionDetailHistoryModel.fromJson(e)).toList();
}
