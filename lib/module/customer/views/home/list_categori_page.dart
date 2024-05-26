import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/module/customer/models/event_model.dart';
import 'package:pasaraja_mobile/module/customer/models/informasi_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_detail_page.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_product.dart';

class ListCategoryPage extends StatefulWidget {
  const ListCategoryPage({
    super.key,
    required this.photo,
    required this.name,
    required this.idCategory,
    required this.prods,
  });

  final String photo;
  final String name;
  final int idCategory;
  final List<ProductModel> prods;

  @override
  State<ListCategoryPage> createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  late List<ProductModel> prodsFilter = [];

  @override
  void initState() {
    super.initState();
    prodsFilter = widget.prods
        .where((element) => element.idCpProd == widget.idCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Detail Informasi'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: widget.photo ?? '',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    widget.name ?? '',
                    style: PasarAjaTypography.sfpdBold.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: prodsFilter.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var prod = prodsFilter[index];
                      return ItemProduct(
                        product: prod,
                        onTap: () {
                          Get.to(
                            ProductDetailPage(
                              idShop: prod.idShop!,
                              idProduct: prod.id!,
                            ),
                            transition: Transition.downToUp,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
