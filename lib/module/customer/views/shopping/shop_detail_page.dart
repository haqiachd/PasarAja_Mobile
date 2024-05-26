import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/widgets/even_title_model.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/config/widgets/gojek_second.dart';
import 'package:pasaraja_mobile/module/customer/models/page/shop_detail_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_detail_page.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_product.dart';
import 'package:provider/provider.dart';

class ShopDetailPage extends StatefulWidget {
  const ShopDetailPage({
    Key? key,
    required this.shopdId,
  }) : super(key: key);

  final int shopdId;

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<CustomerShopDetailProvider>()
          .fetchData(idShop: widget.shopdId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customerSubAppbar('Detail Toko'),
      body: Consumer<CustomerShopDetailProvider>(
        builder: (context, provider, child) {
          if (provider.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (provider.state is OnFailureState) {
            return PageErrorMessage(
                onFailureState: provider.state as OnFailureState);
          }

          if (provider.state is OnSuccessState) {
            ShopDetailModel shopDtl = provider.shopDetail;
            DMethod.log('shop photo : ${shopDtl.shop?.photo}');
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: Get.width,
                    child: CachedNetworkImage(
                      imageUrl: shopDtl.shop?.photo ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          shopDtl.shop?.shopName ?? 'null',
                          style: PasarAjaTypography.sfpdBold
                              .copyWith(fontSize: 25),
                        ),
                        Text(
                          shopDtl.shop?.description ?? 'null',
                          style: PasarAjaTypography.sfpdRegular
                              .copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            provider.chat();
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Chat'),
                              SizedBox(width: 10),
                              Icon(Icons.chat)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  GoFoodSecond(
                    eventTitle: EventTitleModel(
                      icon: PasarAjaImage.gofood,
                      title: 'Rekomenasi Produk',
                      deskripsi: 'Produk yang direkomendasikan oleh Penjual.',
                      haveButton: false,
                      btnTitle: 'Lihat semua',
                      contentSpace: 10,
                    ),
                    models: provider.bestSelling.length >= 10
                        ? provider.bestSelling.getRange(0, 10).toList()
                        : provider.bestSelling,
                  ),
                  const SizedBox(height: 20),
                  GoFoodSecond(
                    eventTitle: EventTitleModel(
                      icon: PasarAjaImage.gofood,
                      title: 'Produk Terlaris',
                      deskripsi:
                          'Produk yang Paling Laris di Toko ${shopDtl.shop?.shopName ?? 'null'}',
                      haveButton: false,
                      btnTitle: 'Lihat semua',
                      contentSpace: 10,
                    ),
                    models: provider.bestSelling.length >= 7
                        ? provider.bestSelling.getRange(0, 7).toList()
                        : provider.bestSelling,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child:
                        Text('Semua Produk', style: PasarAjaTypography.bold16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.products.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        ProductModel prod = provider.products[index];
                        return ItemProduct(
                          product: prod,
                          onTap: () {
                            Get.to(
                              ProductDetailPage(
                                idShop: prod.idShop ?? 0,
                                idProduct: prod.id ?? 0,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }
}
