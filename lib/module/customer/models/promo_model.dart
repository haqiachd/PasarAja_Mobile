import 'package:pasaraja_mobile/core/entities/promo_entity.dart';

class PromoModel extends PromoEntity {
  const PromoModel({
    final int? idPromo,
    final int? idCpProd,
    final int? idShop,
    final int? idProduct,
    final String? productName,
    final String? categoryProd,
    final int? price,
    final int? promoPrice,
    final num? percentage,
    final DateTime? startDate,
    final DateTime? endDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? photo,
  }) : super(
          idPromo: idPromo,
          idCpProd: idCpProd,
          idShop: idShop,
          idProduct: idProduct,
          productName: productName,
          categoryProd: categoryProd,
          price: price,
          promoPrice: promoPrice,
          percentage: percentage,
          startDate: startDate,
          endDate: endDate,
          createdAt: createdAt,
          updatedAt: updatedAt,
          photo: photo,
        );

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        idPromo: json["id_promo"] as int,
        idProduct: json["id_product"] as int,
        promoPrice: json["promo_price"] as int,
        percentage: json["percentage"] as double,
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        idShop: json["id_shop"] as int,
        productName: json["product_name"] ?? '',
        categoryProd: json['category_name'] ?? '',
        idCpProd: json["id_cp_prod"] as int,
        price: json["price"]  as int,
        photo: json["photo"] ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      "promo_price": promoPrice,
      "percentage": percentage,
      "start_date": startDate?.toIso8601String(),
      "end_date": endDate?.toIso8601String(),
    };
  }

  static List<PromoModel> fromList(List<dynamic> json) {
    return json.map((e) => PromoModel.fromJson(e)).toList();
  }
}
