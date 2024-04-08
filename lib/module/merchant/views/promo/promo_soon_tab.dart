import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class PromoSoonTab extends StatefulWidget {
  const PromoSoonTab({super.key});

  @override
  State<PromoSoonTab> createState() => _PromoSoonTabState();
}

class _PromoSoonTabState extends State<PromoSoonTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Promo Soon',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 30,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}
