import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/shop_data_model.dart';

class ItemShop extends StatelessWidget {
  const ItemShop({
    super.key,
    required this.shop,
    required this.onTap,
  });

  final ShopDataModel shop;
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
                imageUrl: shop.photo ?? '',
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
            shop.shopName ?? 'null',
            style: PasarAjaTypography.sfpdBold.copyWith(fontSize: 17),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shop.ownerName ?? 'null',
                maxLines: 2,
                style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 16),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${shop.totalProduct} produk",
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "-",
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${shop.totalSold} terjual",
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
