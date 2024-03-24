import 'package:equatable/equatable.dart';

class ProductCategoriesEntity extends Equatable {
  final int? id;
  final int? categoryCode;
  final String? categoryName;
  final String? photo;

  const ProductCategoriesEntity({
    this.id,
    this.categoryCode,
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
