import 'package:pasaraja_mobile/module/customer/models/event_model.dart';
import 'package:pasaraja_mobile/module/customer/models/informasi_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_categories_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class BerandaModel {
  final List<ShopDataModel>? shops;
  final List<ProductModel>? products;
  final List<ProductCategoryModel>? categories;
  final List<EventModel>? events;
  final List<InformasiModel>? infomasi;

  const BerandaModel({
    this.shops,
    this.products,
    this.categories,
    this.events,
    this.infomasi,
  });

  factory BerandaModel.fromJson(Map<String, dynamic> map) {
    return BerandaModel(
      shops: ShopDataModel.toList(map['shops'] ?? []),
      products: ProductModel.fromList(map['products'] ?? []),
      categories: ProductCategoryModel.fromList(map['categories'] ?? []),
      events: EventModel.fromList(map['events'] ?? []),
      infomasi: InformasiModel.fromList(map['information'] ?? []),
    );
  }
}

