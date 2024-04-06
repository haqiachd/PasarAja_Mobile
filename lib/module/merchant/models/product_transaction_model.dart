import 'package:equatable/equatable.dart';

class ProductTransactionModel extends Equatable {
  final int? idProduct;
  final int? quantity;
  final int? promoPrice;
  final String? notes;

  const ProductTransactionModel({
    required this.idProduct,
    required this.quantity,
    required this.promoPrice,
    this.notes,
  });

  static Map<String, dynamic> toJsonList(
      List<ProductTransactionModel> products) {
    List<Map<String, dynamic>> productListJson = [];

    for (var product in products) {
      productListJson.add({
        'id_product': product.idProduct,
        'quantity': product.quantity,
        'promo_price': product.promoPrice,
        'notes': product.notes,
      });
    }

    return {'products': productListJson};
  }

  @override
  List<Object?> get props {
    return [
      idProduct,
      quantity,
      promoPrice,
      notes,
    ];
  }
}

void main() {
  List<ProductTransactionModel> products = [
    const ProductTransactionModel(
        idProduct: 2, quantity: 2, promoPrice: 0, notes: ''),
    const ProductTransactionModel(
        idProduct: 3, quantity: 2, promoPrice: 2000, notes: 'sambalnya dipisah')
  ];

  print(ProductTransactionModel.toJsonList(products)['products']);
}
