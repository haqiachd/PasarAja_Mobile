import 'package:pasaraja_mobile/module/customer/models/cart_product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class CartModel {
  final int? idShop;
  final ShopDataModel? shopDataModel;
  final List<CartProductModel>? products;

  const CartModel({
    this.idShop,
    this.shopDataModel,
    this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      idShop: json['id_shop'] ?? 0,
      shopDataModel: ShopDataModel.fromJson(json['shop_data']),
      products: CartProductModel.fromList(json['products']),
    );
  }

  static List<CartModel> fromList(List<dynamic> json) {
    return json.map((e) => CartModel.fromJson(e)).toList();
  }
}
