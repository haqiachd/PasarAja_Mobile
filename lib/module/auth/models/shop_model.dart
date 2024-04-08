import 'package:pasaraja_mobile/core/entities/shop_entity.dart';

class ShopModel extends ShopEntity {
  const ShopModel({
    final int? idShop,
    final String? phoneNumber,
    final String? shopName,
    final String? description,
  }) : super(
          idShop: idShop,
          phoneNumber: phoneNumber,
          shopName: shopName,
          description: description,
        );

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      idShop: json['id_shop'] ?? 0,
      phoneNumber: json['shop_phone_number'] ?? '',
      shopName: json['shop_name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
