import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Detail Product", style: PasarAjaTypography.sfpdBold),
      ),
    );
  }
}
