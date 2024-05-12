import 'package:pasaraja_mobile/core/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    final int? idReview,
    final int? idUser,
    final int? idTrx,
    final int? idProduct,
    final String? star,
    final DateTime? orderDate,
    final DateTime? updatedAt,
    final String? comment,
    final String? productName,
    final String? fullName,
    final String? email,
    final String? photo,
  }) : super(
    idReview: idReview,
    idUser: idUser,
    idTrx: idTrx,
    idProduct: idProduct,
    star: star,
    orderDate: orderDate,
    comment: comment,
    productName: productName,
    fullName: fullName,
    email: email,
    photo: photo,
    updatedAt: updatedAt,
  );

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    idReview: json["id_review"] ?? '',
    idUser: json["id_user"] ?? '',
    idTrx: json['id_trx'] ?? '',
    idProduct: json["id_product"] ?? '',
    star: json["star"],
    orderDate: json["order_date"] == null
        ? null
        : DateTime.parse(json["order_date"]),
    comment: json["comment"] ?? '',
    productName: json["product_name"] ?? '',
    fullName: json["full_name"] ?? '',
    email: json["email"] ?? '',
    photo: json["photo"] ?? '',
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  static List<ReviewModel> fromList(List<dynamic> json) {
    return json.map((dynamic i) => ReviewModel.fromJson(i)).toList();
  }
}
