import 'package:pasaraja_mobile/core/entities/verification_entity.dart';

class VerificationModel extends VerificationEntity {
  const VerificationModel({
    final String? id,
    final String? email,
    final String? otp,
    final String? type,
    final int? expirationTime,
    final String? createdAt,
    final String? updatedAt,
  }) : super(
          id: id,
          email: email,
          otp: otp,
          type: type,
          expirationTime: expirationTime,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory VerificationModel.fromJson(Map<String, dynamic> map) {
    return VerificationModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      otp: map['otp'] ?? '',
      type: map['type'] ?? '',
      expirationTime: map['expiration_time'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}
