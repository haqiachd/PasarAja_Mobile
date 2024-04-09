import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderCancelCustomer extends StatefulWidget {
  const OrderCancelCustomer({super.key});

  @override
  State<OrderCancelCustomer> createState() => _OrderCancelCustomerState();
}

class _OrderCancelCustomerState extends State<OrderCancelCustomer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order Cancel By Customer',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}
