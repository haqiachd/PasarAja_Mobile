import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class BerandaModel {
  final List<ShopDataModel>? shops;
  final List<ProductModel>? products;

  const BerandaModel({
    this.shops,
    this.products,
  });

  factory BerandaModel.fromJson(Map<String, dynamic> map) {
    return BerandaModel(
      shops: ShopDataModel.toList(map['shops']),
      products: ProductModel.fromList(map['products']),
    );
  }
}
