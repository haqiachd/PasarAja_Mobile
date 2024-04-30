import 'package:pasaraja_mobile/module/customer/models/review_model.dart';

class RatingModel {
  final num? rating;
  final int? totalReview;
  final List<ReviewModel>? reviewers;

  const RatingModel({
    this.rating,
    this.totalReview,
    this.reviewers,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rating: json['rating'] ?? 0.0,
      totalReview: json['total_review'] ?? 0,
      reviewers: ReviewModel.fromList(json['reviewers'] ?? []),
    );
  }
}
