import 'dart:async';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/customer/views/customer_main_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/merchant_main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Menampilkan indikator loading
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Memeriksa status login pengguna
  void _checkLoginStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 6));

      // mendapatkan data login
      bool isLoggedIn = await PasarAjaUserService.isLoggedIn();

      // jika user sudah login
      if (isLoggedIn) {
        // mendapatkan user level
        String level = await PasarAjaUserService.getUserData(
          PasarAjaUserService.level,
        );
        level = level.toLowerCase();

        DMethod.log("user level : $level");

        // jika user login sebagai penjual
        if (level == UserLevel.penjual.name) {
          // membuka halaman utama
          Get.to(
            const MerchantMainPage(),
          );
        }
        // jika user login sebagai pembeli
        else if (level == UserLevel.pembeli.name) {
          // membuka halaman utama
          Get.offAll(
            const CustomerMainPage(),
          );
        } else {
          Get.snackbar("ERROR", "Your account level is unknown");
        }
      } else {
        DMethod.log("BELUM LOGIN");
        Get.offAll(
          const WelcomePage(),
        );
      }
    } catch (ex) {
      Get.to(
        const WelcomePage(),
      );
    }
  }
}
