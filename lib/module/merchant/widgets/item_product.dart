import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';

class ItemProduct extends StatelessWidget {
  const ItemProduct({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Category : ${product.categoryName}",
                style: PasarAjaTypography.sfpdSemibold,
              ),
              Text(
                "Price : ${PasarAjaUtils.formatPrice(product.price ?? 0)}",
                style: PasarAjaTypography.sfpdSemibold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
