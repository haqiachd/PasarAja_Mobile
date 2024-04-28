import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/bottom_nav_item.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/customer/views/cart/cart_page.dart';
import 'package:pasaraja_mobile/module/customer/views/home/home_page.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_page.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/shopping_page.dart';
import 'package:pasaraja_mobile/module/customer/views/promo/promo_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CustomerMainPage extends StatefulWidget {
  const CustomerMainPage({Key? key}) : super(key: key);

  @override
  State<CustomerMainPage> createState() => _CustomerMainPageState();
}

class _CustomerMainPageState extends State<CustomerMainPage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final mbalek = await PasarAjaMessage.showConfirmBack(
            "Apakah Anda yakin ingin keluar dari PasarAja?",
          );

          if (mbalek) {
            exit(0);
          }
        }
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        navBarHeight: 60,
        screens: _buildScreens,
        items: _navBarsItems,
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        navBarStyle: NavBarStyle.style15,
      ),
    );
  }

  List<Widget> get _buildScreens {
    return [
      const HomePage(),
      const ShoppingPage(),
      const CartPage(),
      const PromoPage(),
      const OrderPage(),
    ];
  }

  List<PersistentBottomNavBarItem> get _navBarsItems {
    return [
      bottomNavItem(
        itemName: "Beranda",
        activeIcon: const Icon(Icons.home),
        inactiveIcon: const Icon(Icons.home_outlined),
      ),
      bottomNavItem(
        itemName: "Belanja",
        activeIcon: const Icon(Icons.badge),
        inactiveIcon: const Icon(Icons.badge_outlined),
      ),
      bottomNavBarItemFloating(
        itemName: "Keranjang",
        onPressed: (o) {
          Get.to(
            const CartPage(),
            transition: Transition.downToUp,
          );
        },
        activeIcon: Icons.shopping_cart_outlined,
        inactiveIcon: Icons.shopping_cart_outlined,
      ),
      bottomNavItem(
        itemName: "Promo",
        activeIcon: const Icon(Icons.discount),
        inactiveIcon: const Icon(Icons.discount_outlined),
      ),
      bottomNavItem(
        itemName: "Pesanan",
        activeIcon: const Icon(Icons.library_books),
        inactiveIcon: const Icon(Icons.library_books_outlined),
      ),
    ];
  }
}
