import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class DetailProductPage extends StatefulWidget {
  final int idProduct;
  const DetailProductPage({
    super.key,
    required this.idProduct,
  });

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
