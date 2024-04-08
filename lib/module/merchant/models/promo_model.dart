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
        idPromo: json["id_promo"],
        idProduct: json["id_product"],
        promoPrice: json["promo_price"],
        percentage: json["percentage"],
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
        idShop: json["id_shop"],
        productName: json["product_name"],
        categoryProd: json['category_name'] ?? '',
        idCpProd: json["id_cp_prod"],
        price: json["price"],
        photo: json["photo"],
      );

  static List<PromoModel> fromList(List<dynamic> json) {
    return json.map((e) => PromoModel.fromJson(e)).toList();
  }
}
