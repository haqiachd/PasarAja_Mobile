import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/coming_soon.dart';

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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: PasarAjaAppbar(
          title: 'Promo',
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Akan Datang'),
              Tab(text: 'Sedang Aktif'),
              Tab(text: 'Kadaluarsa'),
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
