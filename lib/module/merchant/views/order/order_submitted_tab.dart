import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderSubmittedTab extends StatefulWidget {
  const OrderSubmittedTab({super.key});

  @override
  State<OrderSubmittedTab> createState() => _OrderSubmittedTabState();
}

class _OrderSubmittedTabState extends State<OrderSubmittedTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order Submitted',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}