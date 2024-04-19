import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
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
      body: Stack(
        children: [
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: PasarAjaAppbar(
          //     title: 'Toko Saya',
          //     action: PhotoProfile(
          //       onTap: () {
          //         Get.to(const ProfilePage());
          //       },
          //     ),
          //   ),
          // ),
          const ComingSoon(),
        ],
      ),
    );
  }
}
