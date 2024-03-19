import 'dart:async';
import 'package:d_method/d_method.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
// ignore: unused_import
import 'package:pasaraja_mobile/module/auth/views/test_page.dart';
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
      await Future.delayed(const Duration(seconds: 3));
      // mendapatkan data login
      bool isLoggedIn = await PasarAjaUserService.isLoggedIn();

      // get device token
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      DMethod.log('DEVICE TOKEN $deviceToken');

      // Get.to(const MyTestPage(), transition: Transition.downToUp);
      // return;

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
          Get.offAll(
            const MerchantMainPage(),
            transition: Transition.downToUp,
            duration: PasarAjaConstant.transitionDuration,
          );
        }
        // jika user login sebagai pembeli
        else if (level == UserLevel.pembeli.name) {
          // membuka halaman utama
          Get.offAll(
            const CustomerMainPage(),
            transition: Transition.downToUp,
            duration: PasarAjaConstant.transitionDuration,
          );
        } else {
          Get.snackbar("ERROR", "Your account level is unknown");
        }
      } else {
        DMethod.log("BELUM LOGIN");
        Get.offAll(
          const WelcomePage(),
          transition: Transition.downToUp,
          duration: PasarAjaConstant.transitionDuration,
        );
      }
    } catch (ex) {
      Get.offAll(
        const WelcomePage(),
        transition: Transition.downToUp,
        duration: PasarAjaConstant.transitionDuration,
      );
    }
  }
}
