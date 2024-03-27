import 'package:pasaraja_mobile/core/entities/product_histories.dart';

class ProductHistoriesModel extends ProductHistoriesEntity {
  ProductHistoriesModel({
    final int? idDetail,
    final int? idTrx,
    final int? idProduct,
    final int? quantity,
    final int? totalPrice,
    final DateTime? takenDate,
    final String? status,
    final DateTime? createdAt,
    final String? productName,
    final String? fullName,
    final String? email,
    final String? photo,
  }) : super(
          idDetail: idDetail,
          idTrx: idTrx,
          idProduct: idProduct,
          quantity: quantity,
          totalPrice: totalPrice,
          takenDate: takenDate,
          status: status,
          createdAt: createdAt,
          productName: productName,
          fullName: fullName,
          email: email,
          photo: photo,
        );

  factory ProductHistoriesModel.fromJson(Map<String, dynamic> json) =>
      ProductHistoriesModel(
        idDetail: json["id_detail"],
        idTrx: json["id_trx"],
        idProduct: json["id_product"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        takenDate: json["taken_date"] == null
            ? null
            : DateTime.parse(json["taken_date"]),
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        productName: json["product_name"],
        fullName: json["full_name"],
        email: json["email"],
        photo: json["photo"],
      );

  static List<ProductHistoriesModel> fromList(List<dynamic> json) =>
      json.map((dynamic his) => ProductHistoriesModel.fromJson(his)).toList();
}
