import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/coming_soon.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

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
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelStyle: PasarAjaTypography.sfpdBold,
            labelColor: Colors.black,
            unselectedLabelColor: PasarAjaColor.gray5,
            indicatorColor: PasarAjaColor.green1,
            indicatorWeight: 4,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'Permintaan'),
              Tab(text: 'Dalam Pengambilan'),
              Tab(text: 'Diserahkan'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ComingSoon(),
                ComingSoon(),
                ComingSoon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
