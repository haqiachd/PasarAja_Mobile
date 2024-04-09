import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderExpiredTab extends StatefulWidget {
  const OrderExpiredTab({super.key});

  @override
  State<OrderExpiredTab> createState() => _OrderExpiredTabState();
}

class _OrderExpiredTabState extends State<OrderExpiredTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order Expired',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}
