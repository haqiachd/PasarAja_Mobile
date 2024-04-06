import 'package:pasaraja_mobile/core/entities/transaction_detail_entity.dart';

class TransactionDetailModel extends TransactionDetailEntity {
  const TransactionDetailModel({
    final int? idProduct,
    final int? quantity,
    final String? productName,
    final String? productPhoto,
    final String? unit,
    final int? sellingUnit,
    final int? price,
    final int? promoPrice,
  }) : super(
          idProduct: idProduct,
          quantity: quantity,
          productName: productName,
          productPhoto: productPhoto,
          unit: unit,
          sellingUnit: sellingUnit,
          price: price,
          promoPrice: promoPrice,
        );

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      TransactionDetailModel(
        idProduct: json["id_product"],
        quantity: json["quantity"],
        productName: json["product_name"],
        productPhoto: json["product_photo"],
        unit: json["unit"],
        sellingUnit: json["selling_unit"],
        price: json["price"],
        promoPrice: json["promo_price"],
      );

  static List<TransactionDetailModel> fromList(List<dynamic> json) {
    return json.map((e) => TransactionDetailModel.fromJson(e)).toList();
  }
}
