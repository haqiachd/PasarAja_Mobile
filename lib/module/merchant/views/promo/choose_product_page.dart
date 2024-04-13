import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/promo/choose_product_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/promo/add_promo_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_product.dart';
import 'package:provider/provider.dart';

class ChooseProductPage extends StatefulWidget {
  const ChooseProductPage({Key? key}) : super(key: key);

  @override
  State<ChooseProductPage> createState() => _ChooseProductPageState();
}

class _ChooseProductPageState extends State<ChooseProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<ChooseProductProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar("Pilih Produk"),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
          );
          await _fetchData();
        },
        child: Consumer<ChooseProductProvider>(
          builder: (context, prov, child) {
            if (prov.state is OnLoadingState) {
              return const LoadingIndicator();
            }

            if (prov.state is OnFailureState) {
              return PageErrorMessage(
                onFailureState: prov.state as OnFailureState,
              );
            }

            if (prov.state is OnSuccessState) {
              List<ProductModel> products = prov.products;
              if (products.isNotEmpty) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    ProductModel prod = products[index];
                    return ItemProduct(
                      product: products[index],
                      onTap: () {
                        Get.to(
                          AddPromoPage(
                            idProduct: prod.id ?? 0,
                            productName: prod.productName ?? '',
                            productPrice: prod.price ?? 0,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("Tidak Ada Produk Saat Ini"),
                );
              }
            }

            return const SomethingWrong();
          },
        ),
      ),
    );
  }
}
