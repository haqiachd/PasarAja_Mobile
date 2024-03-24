import 'package:equatable/equatable.dart';

class ComplainEntity extends Equatable {
  final int? idComplain;
  final int? idUser;
  final int? idShop;
  final int? idProduct;
  final String? reason;
  final String? productName;
  final String? productPhoto;
  final String? fullName;
  final String? email;
  final String? userPhoto;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ComplainEntity({
    this.idComplain,
    this.idUser,
    this.idShop,
    this.idProduct,
    this.reason,
    this.productName,
    this.productPhoto,
    this.fullName,
    this.email,
    this.userPhoto,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      idComplain,
      idUser,
      idShop,
      idProduct,
      reason,
      productName,
      productPhoto,
      fullName,
      email,
      userPhoto,
      createdAt,
      updatedAt,
    ];
  }
}
