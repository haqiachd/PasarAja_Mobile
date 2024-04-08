import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class PromoActiveTab extends StatefulWidget {
  const PromoActiveTab({super.key});

  @override
  State<PromoActiveTab> createState() => _PromoActiveTabState();
}

class _PromoActiveTabState extends State<PromoActiveTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Promo Active',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 30,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}