import 'package:pasaraja_mobile/core/entities/shop_entity.dart';
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
        );

  factory ShopDataModel.fromJson(Map<String, dynamic> json) {
    return ShopDataModel(
      idShop: json['id_shop'] ?? 0,
      idUser: json['id_user'] ?? 0,
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
      totalSold: json['total_sold'] ?? 0,
      totalProduct: json['total_product'] ?? 0,
    );
  }

  static List<ShopDataModel> toList(List<dynamic> json){
    return json.map((e) => ShopDataModel.fromJson(e)).toList();
  }
}
