import 'package:pasaraja_mobile/core/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    final int? idReview,
    final int? idUser,
    final int? idProduct,
    final String? star,
    final DateTime? orderDate,
    final String? comment,
    final String? productName,
    final String? fullName,
    final String? email,
    final String? photo,
  }) : super(
          idReview: idReview,
          idUser: idUser,
          idProduct: idProduct,
          star: star,
          orderDate: orderDate,
          comment: comment,
          productName: productName,
          fullName: fullName,
          email: email,
          photo: photo,
        );

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        idReview: json["id_review"] ?? '',
        idUser: json["id_user"] ?? '',
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
      );

  static List<ReviewModel> fromList(List<dynamic> json) {
    return json.map((dynamic i) => ReviewModel.fromJson(i)).toList();
  }
}
