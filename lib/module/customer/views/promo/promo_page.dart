import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/coming_soon.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_detail_page.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/provider/promo/promo_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_product.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_category.dart';
import 'package:provider/provider.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fetcthData();
    });
  }

  Future<void> fetcthData() async {
    await context.read<CustomerPromoProvider>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await PasarAjaConstant.onRefreshDelay;
        fetcthData();
      },
      child: Scaffold(
        backgroundColor: PasarAjaColor.white,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(97 - MediaQuery.of(context).padding.top),
          child: const PasarAjaAppbar(
            title: 'Promo',
          ),
        ),
        body: Consumer<CustomerPromoProvider>(
          builder: (context, provider, child) {
            if (provider.state is OnLoadingState) {
              return const LoadingIndicator();
            }

            if (provider.state is OnFailureState) {
              return PageErrorMessage(
                  onFailureState: provider.state as OnFailureState);
            }

            if (provider.state is OnSuccessState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    _listCategory(),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: provider.products.length,
                      itemBuilder: (context, index) {
                        var prod = provider.products[index];
                        return ItemProduct(
                          product: prod,
                          onTap: () {
                            Get.to(
                              ProductDetailPage(
                                idShop: prod.idShop!,
                                idProduct: prod.id!,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            return SomethingWrong();
          },
        ),
      ),
    );
  }

  _listCategory() {
    return Consumer<CustomerPromoProvider>(
      builder: (context, value, child) {
        DMethod.log("build categories");
        // get selected category
        // String ctgSelected =
        // context.select((CustomerPromoProvider prod) => prod.category);
        // // get list
        // List<ProductCategoryModel> categories =
        //     context.read<ProductProvider>().categories;
        // // test show data
        // for (final category in categories) {
        //   // DMethod.log("name -> ${category.categoryName}");
        // }
        //
        return SizedBox(
          height: 152,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: value.categories
                  .map(
                    (element) => ItemCategory(
                      category: element,
                      selected: false,
                      onTap: () {
                        //   Provider.of<CustomerPromoProvider>(
                        //     context,
                        //     listen: false,
                        //   ).category = e.categoryName ?? 'Semua';
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
