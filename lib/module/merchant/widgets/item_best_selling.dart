import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class ItemBestSelling extends StatelessWidget {
  const ItemBestSelling({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: product.photo ?? '',
              placeholder: (context, url) {
                return const CupertinoActivityIndicator();
              },
              errorWidget: (context, url, error) {
                return const Text("ALT IMAGE");
              },
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          product.productName ?? 'null',
          style: PasarAjaTypography.sfpdBold,
        ),
        subtitle: Text(
          "Total Terjual : ${product.totalSold}",
          style: PasarAjaTypography.sfpdRegular,
        ),
      ),
    );
  }
}
