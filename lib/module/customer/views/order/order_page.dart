import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/coming_soon.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(97 - MediaQuery.of(context).padding.top),
        child: const PasarAjaAppbar(
          title: 'Riwayat Pesanan',
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
