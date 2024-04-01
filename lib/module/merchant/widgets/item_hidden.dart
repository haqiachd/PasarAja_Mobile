import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class ItemHidden extends StatelessWidget {
  const ItemHidden({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
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
            "Disembunyikan sejak : ${product.updatedAt?.toIso8601String().substring(0, 10)}",
            style: PasarAjaTypography.sfpdRegular,
          ),
        ),
      ),
    );
  }
}
