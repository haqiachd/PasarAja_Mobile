import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_cancel_customer_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_cancel_merchant_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_confirmed_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_expired_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_finished_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_intaking_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_request_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_submitted_tab.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(97 - MediaQuery.of(context).padding.top),
        child: const PasarAjaAppbar(
          title: 'Pesanan',
        ),
      ),
      body: DefaultTabController(
        length: 8,
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
                  Tab(text: 'Permintaan'),
                  Tab(text: 'Dikonfirmasi'),
                  Tab(text: 'Dalam Pengambilan'),
                  Tab(text: 'Diserahkan'),
                  Tab(text: "Selesai"),
                  Tab(text: "Dibatalkan Penjual"),
                  Tab(text: "Dibatalkan Pembeli"),
                  Tab(text: "Kadaluarsa"),
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
                      OrderRequestTab(),
                      OrderConfirmedTab(),
                      OrderInTakingTab(),
                      OrderSubmittedTab(),
                      OrderFinished(),
                      OrderCancelMerchant(),
                      OrderCancelCustomer(),
                      OrderExpiredTab(),
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
