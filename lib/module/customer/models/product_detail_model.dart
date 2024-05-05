import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/rating_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class ProductDetailModel {
  final ShopDataModel? shopData;
  final ProductModel? product;
  final RatingModel? reviews;

  const ProductDetailModel({
    this.shopData,
    this.product,
    this.reviews,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      shopData: json['shop_data'] != null
          ? ShopDataModel.fromJson(json['shop_data'])
          : const ShopDataModel(),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : const ProductModel(),
      reviews: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : const RatingModel(),
    );
  }
}
