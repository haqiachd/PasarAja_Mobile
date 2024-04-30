import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_tab.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/shop_tab.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(97 - MediaQuery.of(context).padding.top),
        child: const PasarAjaAppbar(
          title: 'Belanja',
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: TabBar(
                labelStyle: PasarAjaTypography.sfpdBold,
                labelColor: Colors.black,
                unselectedLabelColor: PasarAjaColor.gray5,
                indicatorColor: PasarAjaColor.green1,
                indicatorWeight: 4,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: 'Toko'),
                  Tab(text: 'Produk'),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ShopTab(),
                      ProductTab(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
