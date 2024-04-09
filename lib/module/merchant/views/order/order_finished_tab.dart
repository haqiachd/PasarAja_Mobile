import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class OrderFinished extends StatefulWidget {
  const OrderFinished({super.key});

  @override
  State<OrderFinished> createState() => _OrderFinishedState();
}

class _OrderFinishedState extends State<OrderFinished> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order Finished',
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 25,
          color: PasarAjaColor.green1,
        ),
      ),
    );
  }
}