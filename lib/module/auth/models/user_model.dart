import 'package:pasaraja_mobile/core/entities/user_entity.dart';

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
  }) : super(
          idUser: idUser,
          phoneNumber: phoneNumber,
          email: email,
          fullName: fullName,
          password: password,
          level: level,
          isVerified: isVerified,
          photo: photo,
        );

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      idUser: map['id_user'] ?? 0,
      phoneNumber: map['phone_number'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? '',
      level: map['level'] ?? '',
      isVerified: map['is_verified'] ?? 0,
      photo: map['photo'] ?? '',
    );
  }
}
