import 'package:pasaraja_mobile/core/entities/highest_rating_entity.dart';

class HighestModel extends HighestRatingEntity {
  const HighestModel({
    final int? idProduct,
    final int? idCpProd,
    final String? productName,
    final String? photo,
    final double? rating,
    final int? reviewer,
  }) : super(
          idProduct: idProduct,
          idCpProd: idCpProd,
          productName: productName,
          photo: photo,
          rating: rating,
          reviewer: reviewer,
        );

  factory HighestModel.fromJson(Map<String, dynamic> map) {
    return HighestModel(
      idProduct: map['id_product'] ?? 0,
      idCpProd: map['id_cp_prod'] ?? 0,
      productName: map['product_name'] ?? '',
      photo: map['photo'] ?? '',
      rating: map['rating'] != null
          ? double.tryParse(map['rating'].toString()) ?? 0.0
          : 0.0,
      reviewer: map['reviewer'] ?? 1,
    );
  }

  static List<HighestModel> fromList(List<dynamic> map) {
    return map
        .map<HighestModel>(
          (dynamic i) => HighestModel.fromJson(i),
        )
        .toList();
  }
}
