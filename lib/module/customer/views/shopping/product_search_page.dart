import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/module/auth/widgets/textfield.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_detail_page.dart';
import 'package:pasaraja_mobile/module/customer/widgets/item_product.dart';
import 'package:provider/provider.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key, required this.products});

  final List<ProductModel> products;

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<ProductSearchProvider>()
          .products = widget.products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Cari Produk'),
      body: Consumer<ProductSearchProvider>(
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
                    controller: provider.cariProd,
                    hintText: 'Cari Produk',
                    onChanged: (value) {
                      provider.cari();
                    },
                    suffixAction: () {
                      provider.cariProd.text = '';
                      provider.cari();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.productsFil.length,
                  itemBuilder: (context, index) {
                    var product =  provider.productsFil[index];
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
        },
      ),
    );
  }
}
