import 'package:equatable/equatable.dart';

class ChooseCategoriesModel extends Equatable {
  final int idCategory;
  final String categoryName;
  final String photo;
  final int prodCount;

  const ChooseCategoriesModel({
    required this.idCategory,
    required this.categoryName,
    required this.photo,
    required this.prodCount,
  });

  factory ChooseCategoriesModel.fromJson(Map<String, dynamic> json) {
    return ChooseCategoriesModel(
      idCategory: json['id_cp_prod'] ?? 0,
      categoryName: json['category_name'] ?? '',
      photo: json['photo'] ?? '',
      prodCount: json['prod_count'] ?? 0,
    );
  }

  static List<ChooseCategoriesModel> fromList(List<dynamic> payload) =>
      payload.map((e) => ChooseCategoriesModel.fromJson(e)).toList();

  @override
  List<Object?> get props {
    return [
      idCategory,
      categoryName,
      photo,
      prodCount,
    ];
  }
}
