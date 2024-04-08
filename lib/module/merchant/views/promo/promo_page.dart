import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/module/merchant/views/promo/promo_active_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/promo/promo_expired_tab.dart';
import 'package:pasaraja_mobile/module/merchant/views/promo/promo_soon_tab.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({Key? key}) : super(key: key);

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage>
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
        child: PasarAjaAppbar(
          title: 'Promo',
          action: ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue),
              foregroundColor: MaterialStatePropertyAll(Colors.white),
            ),
            child: Text(
              "Tambah",
              style: PasarAjaTypography.sfpdBold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelStyle: PasarAjaTypography.sfpdBold,
            labelColor: PasarAjaColor.green1,
            unselectedLabelColor: PasarAjaColor.black,
            indicatorColor: PasarAjaColor.green1,
            indicatorWeight: 4,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: 'Akan Datang'),
              Tab(text: 'Sedang Aktif'),
              Tab(text: 'Kadaluarsa'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                PromoSoonTab(),
                PromoActiveTab(),
                PromoExpiredTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
