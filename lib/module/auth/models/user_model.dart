import 'package:pasaraja_mobile/core/entities/user_entity.dart';
import 'package:pasaraja_mobile/module/auth/models/shop_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    final int? idUser,
    final String? phoneNumber,
    final String? email,
    final String? fullName,
    final String? password,
    final String? level,
    final int? isVerified,
    final String? photo,
    final ShopModel? shopData,
  }) : super(
          idUser: idUser,
          phoneNumber: phoneNumber,
          email: email,
          fullName: fullName,
          password: password,
          level: level,
          isVerified: isVerified,
          photo: photo,
          shopData: shopData,
        );

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      idUser: map['id_user'] ?? 0,
      phoneNumber: map['phone_number'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? '',
      level: map['level'] ?? '',
      // isVerified: map['is_verified'] ?? 0,
      photo: map['photo'] ?? '',
      shopData: map.containsKey('shop_data')
          ? ShopModel.fromJson(map['shop_data'])
          : const ShopModel(),
    );
  }
}
