import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderRequestTab extends StatefulWidget {
  const OrderRequestTab({super.key});

  @override
  State<OrderRequestTab> createState() => _OrderRequestTabState();
}

class _OrderRequestTabState extends State<OrderRequestTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order Request',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}
