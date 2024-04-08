import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/lotties.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class EmptyPromo extends StatelessWidget {
  const EmptyPromo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: LottieBuilder.asset(
              PasarAjaLottie.notFound3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tidak Ada Promo yang Sedang Aktif',
            maxLines: 2,
            style: PasarAjaTypography.sfpdBold.copyWith(
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
