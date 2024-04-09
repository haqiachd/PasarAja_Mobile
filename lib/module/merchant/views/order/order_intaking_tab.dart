import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderInTakingTab extends StatefulWidget {
  const OrderInTakingTab({super.key});

  @override
  State<OrderInTakingTab> createState() => _OrderInTakingTabState();
}

class _OrderInTakingTabState extends State<OrderInTakingTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order InTaking',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}