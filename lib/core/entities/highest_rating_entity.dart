import 'package:equatable/equatable.dart';

class HighestRatingEntity extends Equatable {
  final int? idProduct;
  final String? productName;
  final int? idCpProd;
  final String? photo;
  final double? rating;
  final int? reviewer;

  const HighestRatingEntity({
    this.idProduct,
    this.productName,
    this.idCpProd,
    this.photo,
    this.rating,
    this.reviewer,
  });

  @override
  List<Object?> get props {
    return [
      idProduct,
      productName,
      idCpProd,
      photo,
      rating,
      reviewer,
    ];
  }
}
