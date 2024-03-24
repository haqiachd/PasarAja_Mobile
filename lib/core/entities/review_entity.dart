import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final int? idReview;
  final int? idUser;
  final int? idProduct;
  final String? star;
  final DateTime? orderDate;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productName;
  final String? fullName;
  final String? email;
  final String? photo;

  const ReviewEntity({
    this.idReview,
    this.idUser,
    this.idProduct,
    this.star,
    this.orderDate,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.productName,
    this.fullName,
    this.email,
    this.photo,
  });

  @override
  List<Object?> get props {
    return [
      idReview,
      idUser,
      idProduct,
      star,
      orderDate,
      comment,
      createdAt,
      updatedAt,
      productName,
      fullName,
      email,
      photo,
    ];
  }
}
