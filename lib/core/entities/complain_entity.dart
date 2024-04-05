import 'package:equatable/equatable.dart';

class ComplainEntity extends Equatable {
  final int? idComplain;
  final int? idTrx;
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
  final DateTime? orderDate;

  const ComplainEntity({
    this.idComplain,
    this.idUser,
    this.idTrx,
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
    this.orderDate,
  });

  @override
  List<Object?> get props {
    return [
      idComplain,
      idTrx,
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
      orderDate,
    ];
  }
}
