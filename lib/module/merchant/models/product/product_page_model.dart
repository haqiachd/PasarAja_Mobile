import 'package:pasaraja_mobile/module/merchant/models/highest_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_category_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class ProductPageModel {
  final List<ProductCategoryModel>? categories;
  final List<HighestModel>? highest;
  final List<ProductModel>? products;
  final List<ProductModel>? sellings;

  const ProductPageModel({
    this.categories,
    this.highest,
    this.products,
    this.sellings,
  });

  factory ProductPageModel.fromJson(Map<String, dynamic> map) {
    return ProductPageModel(
      categories: ProductCategoryModel.fromList(map['categories']),
      products: ProductModel.fromList(map['products']),
      highest: HighestModel.fromList(map['highests']),
      sellings: ProductModel.fromList(map['sellings']),
    );
  }
}
