import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_category_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/best_selling_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/complain_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/hidden_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/recommended_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/review_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/unavailable_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/feature_button.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      DMethod.log('fetch api data');
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: "Sometimes Wrong : ${ex.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PasarAjaAppbar(
              title: 'Produk',
            ),
          ),
          Positioned(
            top: 97,
            bottom: 0,
            left: 0,
            right: 0,
            child: RefreshIndicator(
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ProdcutFeatureButton(
                          title: 'Terlaris',
                          onPressed: () {
                            Get.to(
                              const BestSellingPage(),
                              transition: Transition.cupertino,
                            );
                          },
                        ),
                        ProdcutFeatureButton(
                          title: 'Ulasan',
                          onPressed: () {
                            Get.to(
                              const ReviewPage(),
                              transition: Transition.cupertino,
                            );
                          },
                        ),
                        ProdcutFeatureButton(
                          title: 'Komplain',
                          onPressed: () {
                            Get.to(
                              const ComplainPage(),
                              transition: Transition.cupertino,
                            );
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ProdcutFeatureButton(
                            title: 'Stok ',
                            onPressed: () {
                              Get.to(
                                const UnavailablePage(),
                                transition: Transition.cupertino,
                              );
                            },
                          ),
                        ),
                        ProdcutFeatureButton(
                          title: 'Disembuyikan',
                          onPressed: () {
                            Get.to(
                              const HiddenPage(),
                              transition: Transition.cupertino,
                            );
                          },
                        ),
                        ProdcutFeatureButton(
                          title: 'Rekomendasi',
                          onPressed: () {
                            Get.to(
                              const RecommendedPage(),
                              transition: Transition.cupertino,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {},
          heroTag: 'add_prod',
          elevation: 3,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}



class ItemCategory extends StatelessWidget {
  const ItemCategory({
    super.key,
    required this.category,
  });

  final ProductCategoryModel category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: InkWell(
        onTap: () {
          Fluttertoast.showToast(msg: category.categoryName ?? 'null');
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor:
                  Colors.transparent, // Set the background color to transparent
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: category.photo ?? '',
                  placeholder: (context, url) {
                    return Image.asset(PasarAjaImage.icGoogle);
                  },
                  errorWidget: (context, url, error) {
                    return const Text('error');
                  },
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            Text(
              category.categoryName ?? 'null',
              textAlign: TextAlign.center,
              style: PasarAjaTypography.sfpdBold,
            ),
          ],
        ),
      ),
    );
  }
}
