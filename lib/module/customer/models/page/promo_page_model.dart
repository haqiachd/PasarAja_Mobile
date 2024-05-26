import 'package:pasaraja_mobile/module/customer/models/create_transaction_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_categories_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
class PromoPageModel {
  final List<ProductCategoryModel>? categories;
  final List<ProductModel>? products;

  const PromoPageModel({
    this.categories,
    this.products,
  });

  factory PromoPageModel.fromJson(Map<String, dynamic> json){
    return PromoPageModel(
      categories: ProductCategoryModel.fromList(json['categories']),
      products: ProductModel.fromList(json['products'])
    );
  }
}
