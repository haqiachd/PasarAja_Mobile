import 'package:equatable/equatable.dart';

class VerificationEntity extends Equatable {
  final String? id;
  final String? email;
  final String? otp;
  final String? type;
  final int? expirationTime;
  final String? createdAt;
  final String? updatedAt;

  const VerificationEntity({
    this.id,
    this.email,
    this.otp,
    this.type,
    this.expirationTime,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      id,
      email,
      otp,
      type,
      expirationTime,
      createdAt,
      updatedAt,
    ];
  }
}
