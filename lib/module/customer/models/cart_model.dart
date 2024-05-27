import 'package:pasaraja_mobile/core/utils/parsing.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class CartModel {
  final int? idShop;
  final ShopDataModel? shopDataModel;
  final List<CartProductModel>? products;
   bool checkedAll;

   CartModel({
    this.idShop,
    this.shopDataModel,
    this.products,
    this.checkedAll = false,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      idShop:  PasarAjaParsing.tryInt(json['id_shop']),
      shopDataModel: json['shop_data'] != null ? ShopDataModel.fromJson(json['shop_data']) : const ShopDataModel(),
      products: json['products'] != null ? CartProductModel.fromList(json['products']) : [],
    );
  }

  static List<CartModel> fromList(List<dynamic> json) {
    return json.map((e) => CartModel.fromJson(e)).toList();
  }
}
