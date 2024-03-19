import 'package:equatable/equatable.dart';

class ShopCategories extends Equatable {
  final int? id;
  final String? categoryName;
  final String? photo;

  const ShopCategories({
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
