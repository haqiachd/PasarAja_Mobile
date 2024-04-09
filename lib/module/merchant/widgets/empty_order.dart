import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/lotties.dart';

class EmptyOrder extends StatelessWidget {
  const EmptyOrder(
    this.title, {
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: LottieBuilder.asset(
                    PasarAjaLottie.noOrder,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 2,
                  style: PasarAjaTypography.sfpdBold.copyWith(
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
