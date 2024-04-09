import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderCancelMerchant extends StatefulWidget {
  const OrderCancelMerchant({super.key});

  @override
  State<OrderCancelMerchant> createState() => _OrderCancelMerchantState();
}

class _OrderCancelMerchantState extends State<OrderCancelMerchant> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order Cancel by Merchant',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}