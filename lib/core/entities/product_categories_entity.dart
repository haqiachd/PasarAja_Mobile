import 'package:equatable/equatable.dart';

class ProductCategories extends Equatable {
  final int? id;
  final String? categoryName;
  final String? photo;

  const ProductCategories({
    this.id,
    this.categoryName,
    this.photo,
  });

  @override
  List<Object?> get props {
    return [
      id,
      categoryName,
      photo,
    ];
  }
}
