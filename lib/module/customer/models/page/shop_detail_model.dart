import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class ShopDetailModel {
  final ShopDataModel? shop;
  final List<ProductModel>? products;

  const ShopDetailModel({
    this.shop,
    this.products,
  });

  factory ShopDetailModel.fromJson(Map<String, dynamic> json){
    return ShopDetailModel(
      shop: ShopDataModel.fromJson(json['shop_data']),
      products: ProductModel.fromList(json['products'])
    );
  }
}
