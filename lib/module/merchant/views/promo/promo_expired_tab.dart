import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class PromoExpiredTab extends StatefulWidget {
  const PromoExpiredTab({super.key});

  @override
  State<PromoExpiredTab> createState() => _PromoExpiredTabState();
}

class _PromoExpiredTabState extends State<PromoExpiredTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Promo Expired',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 30,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}