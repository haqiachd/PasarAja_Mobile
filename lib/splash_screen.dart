import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/views/test_page.dart';
import 'package:pasaraja_mobile/splash_screen_provider.dart';
import 'package:provider/provider.dart';

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
              Visibility(
                visible: context.read<SplashScreenProvider>().visibleLoading,
                child: const SizedBox(
                  height: 10,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
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
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        try {
          await context.read<SplashScreenProvider>().prepareApp(context);
        } catch (ex) {
          PasarAjaMessage.showSnackbarError(ex.toString());
        }
      },
    );
  }
}
