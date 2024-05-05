import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';

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
              PasarAjaUtils.isActivePromo(product.promo)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Rp. ${PasarAjaUtils.formatPrice(product.price ?? 0)}",
                          style: PasarAjaTypography.sfpdSemibold.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "Rp. ${PasarAjaUtils.formatPrice(product.promo?.promoPrice ?? 0)} (${product.promo?.percentage} %)",
                          style: PasarAjaTypography.sfpdSemibold,
                        ),
                      ],
                    )
                  : Text(
                      "Rp. ${PasarAjaUtils.formatPrice(product.price ?? 0)}",
                      style: PasarAjaTypography.sfpdSemibold,
                    ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.star,
                    size: 20,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    (product.rating ?? 0.0) > 0.0 ? '${product.rating}' : 'N/A',
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  const SizedBox(width: 5),
                  Visibility(
                    visible: (product.rating ?? 0.0) > 0.0,
                    child: Text(
                      '(${product.totalReview} ulasan)',
                      style: PasarAjaTypography.sfpdRegular,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '-',
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${product.totalSold} terjual',
                    style: PasarAjaTypography.sfpdRegular,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
