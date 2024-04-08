import 'dart:async';
import 'package:d_method/d_method.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity / 2,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.centerRight,
                    colors: [
                      PasarAjaColor.green2,
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                PasarAjaImage.pasaraja,
              ),
              const SizedBox(
                height: 10,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _checkLoginStatus();
  }

  // Memeriksa status login pengguna
  void _checkLoginStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      // mendapatkan data login
      bool isLoggedIn = await PasarAjaUserService.isLoggedIn();

      // get device info
      String? deviceName = await PasarAjaUtils.getDeviceModel();
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      DMethod.log('DEVICE NAME : $deviceName');
      DMethod.log('DEVICE TOKEN : $deviceToken');

      // Get.to(const MyTestPage(), transition: Transition.downToUp);
      // return;

      // jika user sudah login
      if (isLoggedIn) {
        // mendapatkan user data
        String email = await PasarAjaUserService.getUserData(
          PasarAjaUserService.email,
        );
        String level = await PasarAjaUserService.getUserData(
          PasarAjaUserService.level,
        );
        level = level.toLowerCase();
        DMethod.log("Login as : $email");
        DMethod.log("user level : $level");
        DMethod.log(
          "expired on : ${await FlutterSessionJwt.getExpirationDateTime()}",
        );

        // cek sesi masih aktif atau tidak
        if (await FlutterSessionJwt.isTokenExpired()) {
          await PasarAjaMessage.showInformation(
            "Sesi Anda Telah Berakhir. Silakan Login Kembali.",
            actionYes: "Login",
            barrierDismissible: false,
          );

          // buka halaman welcome
          Get.offAll(
            const WelcomePage(),
            transition: Transition.downToUp,
            duration: PasarAjaConstant.transitionDuration,
          );

          return;
        }

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
