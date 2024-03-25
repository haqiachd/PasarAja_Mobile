import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_category_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/add_product_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/best_selling_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/complain_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/detail_product_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/hidden_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/recommended_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/review_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/product/unavailable_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/feature_button.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_category.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_product.dart';
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
            left: 0,
            right: 0,
            bottom: 0,
            child: RefreshIndicator(
              onRefresh: () async {
                await PasarAjaConstant.onRefreshDelay;
                _fetchData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProductFeature(),
                      const SizedBox(height: 10),
                      Text(
                        'Ketegori Produk',
                        style: PasarAjaTypography.sfpdBold.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Builder(
                        builder: (context) {
                          DMethod.log("build categories");
                          // get selected category
                          String ctgSelected = context
                              .select((ProductProvider prod) => prod.category);
                          // get list
                          List<ProductCategoryModel> categories =
                              context.read<ProductProvider>().categories;
                          return SizedBox(
                            height: 151,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: categories
                                    .map(
                                      (e) => ItemCategory(
                                        category: e,
                                        selected: ctgSelected == e.categoryName,
                                        onTap: () {
                                          Provider.of<ProductProvider>(
                                            context,
                                            listen: false,
                                          ).category =
                                              e.categoryName ?? 'Semua';
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      ),
                      Consumer<ProductProvider>(
                        builder: (context, value, child) {
                          DMethod.log("consume genres");
                          if (value.state is OnLoadingState) {
                            return const LoadingIndicator();
                          }

                          if (value.state is OnFailureState) {
                            return PageErrorMessage(
                              onFailureState: value.state as OnFailureState,
                            );
                          }

                          if (value.state is OnSuccessState) {
                            if (value.category == 'Semua') {
                              return Column(
                                children: value.products
                                    .map(
                                      (e) => ItemProduct(
                                        product: e,
                                        onTap: () {
                                          Get.to(
                                            DetailProductPage(
                                              idProduct: e.id ?? 0,
                                            ),
                                            transition: Transition.zoom,
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            } else {
                              // filter produk
                              List<ProductModel> list = value.products
                                  .where((element) =>
                                      element.categoryName == value.category)
                                  .toList();
                              if (list.isNotEmpty) {
                                return Column(
                                  children: list
                                      .map(
                                        (e) => ItemProduct(
                                          product: e,
                                          onTap: () {
                                            Get.to(
                                              DetailProductPage(
                                                idProduct: e.id ?? 0,
                                              ),
                                              transition: Transition.zoom,
                                            );
                                          },
                                        ),
                                      )
                                      .toList(),
                                );
                              } else {
                                return SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Text(
                                      'Data Kosong',
                                      style:
                                          PasarAjaTypography.sfpdBold.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          }

                          return const SomethingWrong();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Get.to(
              const AddProductPage(),
              transition: Transition.downToUp,
            );
          },
          heroTag: 'add_prod',
          elevation: 3,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ProductFeature extends StatelessWidget {
  const ProductFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            // best_selling_page.dart
            ProdcutFeatureButton(
              title: 'Terlaris',
              onPressed: () {
                Get.to(
                  const BestSellingPage(),
                  transition: Transition.cupertino,
                );
              },
            ),
            // review_page.dart
            ProdcutFeatureButton(
              title: 'Ulasan',
              onPressed: () {
                Get.to(
                  const ReviewPage(),
                  transition: Transition.cupertino,
                );
              },
            ),
            // complain_page.dart
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
              // unavailable_page.dart
              child: ProdcutFeatureButton(
                title: 'Stok',
                onPressed: () {
                  Get.to(
                    const UnavailablePage(),
                    transition: Transition.cupertino,
                  );
                },
              ),
            ),
            // hidden_page.dart
            ProdcutFeatureButton(
              title: 'Disembunyikan',
              onPressed: () {
                Get.to(
                  const HiddenPage(),
                  transition: Transition.cupertino,
                );
              },
            ),
            ProdcutFeatureButton(
              // recommended_page.dart
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
    );
  }
}
