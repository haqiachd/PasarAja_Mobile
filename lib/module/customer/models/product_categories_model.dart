import 'package:pasaraja_mobile/core/entities/product_categories_entity.dart';

class ProductCategoryModel extends ProductCategoriesEntity {
  const ProductCategoryModel({
    final int? idCategory,
    final int? categoryCode,
    final String? categoryName,
    final String? photo,
  }) : super(
    id: idCategory,
    categoryCode: categoryCode,
    categoryName: categoryName,
    photo: photo,
  );

  factory ProductCategoryModel.fromJson(Map<String, dynamic> payload) {
    return ProductCategoryModel(
      idCategory: payload['id_cp_prod'] ?? 0,
      categoryCode: payload['category_code'] ?? 0,
      categoryName: payload['category_name'] ?? '',
      photo: payload['photo'] ?? '',
    );
  }

  static List<ProductCategoryModel> fromList(List<dynamic> payload) {
    return payload
        .map<ProductCategoryModel>(
          (dynamic i) => ProductCategoryModel.fromJson(i),
    )
        .toList();
  }
}
