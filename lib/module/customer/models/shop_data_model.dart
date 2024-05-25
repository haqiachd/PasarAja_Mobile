import 'package:pasaraja_mobile/core/entities/shop_entity.dart';
import 'package:pasaraja_mobile/core/utils/parsing.dart';
import 'package:pasaraja_mobile/module/merchant/models/operational_model.dart';

class ShopDataModel extends ShopEntity {
  const ShopDataModel({
    final int? idShop,
    final int? idUser,
    final String? phoneNumber,
    final String? shopName,
    final String? description,
    final String? benchmark,
    final OperationalModel? operational,
    final String? photo,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? ownerName,
    final int? totalProduct,
    final int? totalSold,
    final int? totalPromo,
    final int? totalTransaction,
    final int? totalReview,
    final num? totalRating,
    final int? totalComplain,
  }) : super(
          idShop: idShop,
          idUser: idUser,
          phoneNumber: phoneNumber,
          shopName: shopName,
          description: description,
          benchmark: benchmark,
          photo: photo,
          createdAt: createdAt,
          updatedAt: updatedAt,
          ownerName: ownerName,
          totalProduct: totalProduct,
          totalSold: totalSold,
          totalPromo: totalPromo,
          totalTransaction: totalTransaction,
          totalReview: totalReview,
          totalRating: totalRating,
          totalComplain: totalComplain,
        );

  factory ShopDataModel.fromJson(Map<String, dynamic> json) {
    return ShopDataModel(
      idShop: PasarAjaParsing.tryInt(json['id_shop']),
      idUser: PasarAjaParsing.tryInt(json['id_user']),
      phoneNumber: json['phone_number'] ?? '',
      shopName: json['shop_name'] ?? '',
      description: json['description'] ?? '',
      benchmark: json['benchmark'] ?? '',
      photo: json['photo'] ?? '',
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      ownerName: json['owner_name'] ?? '',
      totalSold: PasarAjaParsing.tryInt(json['total_sold']),
      totalProduct: PasarAjaParsing.tryInt(json['total_product']),
      totalPromo: PasarAjaParsing.tryInt(json['total_promo']),
      totalTransaction: PasarAjaParsing.tryInt(json['total_transaction']),
      totalReview: PasarAjaParsing.tryInt(json['total_review']),
      totalRating: PasarAjaParsing.tryInt(json['total_rating']),
      totalComplain: PasarAjaParsing.tryInt(json['total_complain']),
    );
  }

  static List<ShopDataModel> toList(List<dynamic> json) {
    return json.map((e) => ShopDataModel.fromJson(e)).toList();
  }
}
