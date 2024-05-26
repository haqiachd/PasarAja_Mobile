import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/module/customer/models/product_categories_model.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_detail_page.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/provider/promo/promo_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_category.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_product.dart';
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
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(97 - MediaQuery.of(context).padding.top),
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
              onFailureState: provider.state as OnFailureState,
            );
          }

          if (provider.state is OnSuccessState) {
            return RefreshIndicator(
              onRefresh: () async {
                await PasarAjaConstant.onRefreshDelay;
                fetcthData();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _listCategory(),
                    const SizedBox(height: 10),
                    _listProduct(),
                  ],
                ),
              ),
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }

  _listCategory() {
    return Consumer<CustomerPromoProvider>(
      builder: (context, value, child) {
        DMethod.log("build categories");
        // get selected category
        int ctgSelected =
        context.select((CustomerPromoProvider prod) => prod.category);
        // get list
        List<ProductCategoryModel> categories =
            context.read<CustomerPromoProvider>().categories;
        return SizedBox(
          height: 152,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories
                  .map(
                    (e) => CusItemCategory(
                  category: e,
                  selected: ctgSelected == e.id,
                  onTap: () {
                    DMethod.log('ctg selected : ${e.categoryName}');
                    Provider.of<CustomerPromoProvider>(
                      context,
                      listen: false,
                    ).category = e.id ?? 1;
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

  _listProduct() {
    return Consumer<CustomerPromoProvider>(
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
          DMethod.log('categoryy  : ${value.categories}');
          if (value.category == 1) {
            return Column(
              children: value.products
                  .map(
                    (e) => ItemProduct(
                      product: e,
                      onTap: () {
                        Get.to(
                          ProductDetailPage(
                              idShop: e.idShop!, idProduct: e.id!),
                        );
                      },
                    ),
                  )
                  .toList(),
            );
          } else {
            for(var p in value.products){
              DMethod.log('prod : ${p.categoryName}');
            }
            // filter produk
            List<ProductModel> list = value.products
                .where((element) => element.idCpProd == value.category)
                .toList();
            // List<ProductModel> list = value.products;
            if (list.isNotEmpty) {
              return Column(
                children: list
                    .map(
                      (e) => ItemProduct(
                        product: e,
                        onTap: () {
                          // Get.to(
                          //   DetailProductPage(
                          //     idProduct: e.id ?? 0,
                          //   ),
                          //   transition: Transition.zoom,
                          // );
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
                    style: PasarAjaTypography.sfpdBold.copyWith(
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
    );
  }
}
