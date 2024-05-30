import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/module/auth/widgets/textfield.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/shop_detail_page.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_shop.dart';
import 'package:provider/provider.dart';

class ShopSearchPage extends StatefulWidget {
  const ShopSearchPage({
    super.key,
    required this.shops,
  });

  final List<ShopDataModel> shops;

  @override
  State<ShopSearchPage> createState() => _ShopSearchPageState();
}

class _ShopSearchPageState extends State<ShopSearchPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ShopSearchProvider>().shops = widget.shops;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Cari Toko'),
      body: Consumer<ShopSearchProvider>(
        builder: (context, provider, child) {
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
                    suffixAction: () {
                      provider.cariShop.text = '';
                      provider.cari();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.shopFil.length,
                  itemBuilder: (context, index) {
                    var shop = provider.shopFil[index];
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
        },
      ),
    );
  }
}
