import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/auth/widgets/textfield.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_detail_page.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_product.dart';
import 'package:provider/provider.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({Key? key}) : super(key: key);

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<CustomerProductProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CustomerProductProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<CustomerProductProvider>(
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: AuthTextField(
                      controller: provider.cariProd,
                      hintText: 'Cari Produk',
                      onChanged: (value) {
                        provider.cari();
                      },
                      suffixAction: (){
                        provider.cariProd.text = '';
                        provider.cari();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.cariProd.text.trim().isEmpty
                        ? provider.products.length
                        : provider.productsFil.length,
                    itemBuilder: (context, index) {
                      var product = provider.cariProd.text.trim().isEmpty
                          ? provider.products[index]
                          : provider.productsFil[index];
                      return ItemProduct(
                        product: product,
                        onTap: () {
                          Get.to(
                            ProductDetailPage(
                              idShop: product.idShop ?? 0,
                              idProduct: product.id ?? 0,
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

          return const SomethingWrong();
        },
      ),
    );
  }
}
