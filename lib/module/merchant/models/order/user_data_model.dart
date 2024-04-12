import 'package:pasaraja_mobile/core/entities/user_entity.dart';

class UserDataModel extends UserEntity {
  const UserDataModel({
    final int? idUser,
    final String? fullName,
    final String? email,
    final String? phoneNumber,
    final String? userPhoto,
  }) : super(
          idUser: idUser,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          photo: userPhoto,
        );

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      idUser: json['id_user'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userPhoto: json['user_photo'] ?? '',
    );
  }
}
