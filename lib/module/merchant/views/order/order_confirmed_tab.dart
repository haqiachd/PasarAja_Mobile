import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderConfirmedTab extends StatefulWidget {
  const OrderConfirmedTab({super.key});

  @override
  State<OrderConfirmedTab> createState() => _OrderConfirmedTabState();
}

class _OrderConfirmedTabState extends State<OrderConfirmedTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order Confirmed',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}
