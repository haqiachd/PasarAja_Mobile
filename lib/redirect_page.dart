import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/lotties.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/splash_screen_provider.dart';
import 'package:provider/provider.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({
    Key? key,
    required this.status,
  }) : super(key: key);

  final String status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<SplashScreenProvider>().prepareApp(context);
        },
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [_buildBody()],
          ),
        ),
      ),
    );
  }

  _buildBody() {
    switch (status) {
      case 'maintenance':
        {
          return const RedirectMessage(
            lottieAsset: PasarAjaLottie.maintenance,
            message: 'Maaf, server sedang dalam perbaikan oleh Developer.',
          );
        }
      case 'inactive':
        {
          return const RedirectMessage(
            lottieAsset: PasarAjaLottie.sleep,
            message: 'Maaf, server sedang dinonaktifkan.',
          );
        }
      default:
        {
          return const RedirectMessage(
            lottieAsset: PasarAjaLottie.somethingWrong,
            message: 'Something Wrong.',
          );
        }
    }
  }
}

class RedirectMessage extends StatelessWidget {
  const RedirectMessage({
    super.key,
    required this.lottieAsset,
    required this.message,
  });

  final String lottieAsset;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(lottieAsset),
            Text(
              message,
              textAlign: TextAlign.center,
              style: PasarAjaTypography.bold24,
            ),
          ],
        ),
      ),
    );
  }
}
