import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? status;
  final String? message;
  final dynamic data;
  final int? id;
  final String? phoneNumber;
  final String? email;
  final String? fullName;
  final String? password;
  final String? pin;
  final String? level;
  final int? isVerified;
  final String? photo;
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    this.status,
    this.message,
    this.data,
    this.id,
    this.phoneNumber,
    this.email,
    this.fullName,
    this.password,
    this.pin,
    this.level,
    this.isVerified,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      data: map,
      id: map['id'] ?? 0,
      phoneNumber: map['phone_number'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? '',
      password: map['password'] ?? '',
      pin: map['pin'] ?? '',
      level: map['level'] ?? '',
      isVerified: map['is_verified'] ?? 0,
      photo: map['photo'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      phoneNumber,
      email,
      fullName,
      password,
      pin,
      level,
      isVerified,
      phoneNumber,
      createdAt,
      updatedAt,
    ];
  }
}
