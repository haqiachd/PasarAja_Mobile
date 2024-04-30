import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/rating_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class ProductDetailModel {
  final ShopDataModel? shopData;
  final ProductModel? products;
  final RatingModel? reviews;

  const ProductDetailModel({
    this.shopData,
    this.products,
    this.reviews,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      shopData: ShopDataModel.fromJson(json['shop_data']),
      products: ProductModel.fromJson(json['product']),
      reviews: RatingModel.fromJson(json['rating']),
    );
  }
}
