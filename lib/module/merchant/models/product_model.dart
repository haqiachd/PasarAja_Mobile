import 'package:pasaraja_mobile/core/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    final int? idProduct,
    final int? idShop,
    final int? idCpProd,
    final String? productName,
    final String? description,
    final int? sellingUnit,
    final String? unit,
    final int? price,
    final int? totalSold,
    final String? photo,
  }) : super(
          id: idProduct,
          idShop: idShop,
          idCpProd: idCpProd,
          productName: productName,
          description: description,
          sellingUnit: sellingUnit,
          unit: unit,
          price: price,
          totalSold: totalSold,
          photo: photo,
        );

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      idProduct: map['id_product'] ?? 0,
      idShop: map['id_shop'] ?? 0,
      idCpProd: map['id_cp_prod'] ?? 0,
      productName: map['product_name'] ?? '',
      description: map['description'] ?? '',
      sellingUnit: map['selling_unit'] ?? 0,
      unit: map['unit'] ?? '',
      price: map['price'] ?? 0,
      totalSold: map['total_sold'] ?? 0,
      photo: map['photo'] ?? '',
    );
  }

  static List<ProductModel> fromList(List<dynamic> payload) {
    return payload
        .map<ProductModel>(
            (dynamic i) => ProductModel.fromJson(i as Map<String, dynamic>))
        .toList();
  }
}
