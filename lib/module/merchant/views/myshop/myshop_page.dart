import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/app_bar.dart';
import 'package:pasaraja_mobile/config/widgets/coming_soon.dart';
import 'package:pasaraja_mobile/module/merchant/providers/myshop/myshop_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/myshop/profile_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/photo_profile.dart';
import 'package:provider/provider.dart';

class MyShopPage extends StatefulWidget {
  const MyShopPage({super.key});

  @override
  State<MyShopPage> createState() => _MyShopPageState();
}

class _MyShopPageState extends State<MyShopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<MyShopProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PasarAjaColor.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          97 - MediaQuery.of(context).padding.top,
        ),
        child: Consumer<MyShopProvider>(
          builder: (context, provider, child) {
            return PasarAjaAppbar(
              title: 'Toko Saya',
              action: PhotoProfile(
                photoPath: provider.photoProfile,
                onTap: () {
                  Get.to(const ProfilePage());
                },
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              width: 450,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Text(
                "Nama Kios Mitra",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 60),
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(7)),
                ),

                SizedBox(
                  width: 70,
                ),

                Container(
                  height: 40,
                  width: 140,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(7)),
                ),
                
              ],
            ),
            Text("data", style: PasarAjaTypography.sfpdBoldAuthInput,)
          ],
        ),
      ),
    );
  }
}
