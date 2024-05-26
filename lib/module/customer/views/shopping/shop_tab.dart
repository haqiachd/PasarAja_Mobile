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
import 'package:pasaraja_mobile/module/customer/views/shopping/shop_detail_page.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_shop.dart';
import 'package:provider/provider.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({Key? key}) : super(key: key);

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<CustomerShopProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CustomerShopProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<CustomerShopProvider>(
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
            var shops = provider.shops;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: AuthTextField(
                      controller: provider.cariShop,
                      hintText: 'Cari Toko',
                      onChanged: (value) {
                        provider.cari();
                      },
                      suffixAction: (){
                        provider.cariShop.text = '';
                        provider.cari();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.cariShop.text.trim().isEmpty
                        ? provider.shops.length
                        : provider.shopsFil.length,
                    itemBuilder: (context, index) {
                      var shop = provider.cariShop.text.trim().isEmpty
                          ? provider.shops[index]
                          : provider.shopsFil[index];
                      return ItemShop(
                        shop: shop,
                        onTap: () {
                          Get.to(ShopDetailPage(shopdId: shop.idShop!));
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
