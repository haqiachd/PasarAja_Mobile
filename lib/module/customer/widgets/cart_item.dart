import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_product_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  final CartProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productData?.productName ?? 'null',
          maxLines: 2,
          style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${PasarAjaUtils.formatPrice(product.productData?.price ?? 0)} / ${product.productData?.sellingUnit} ${product.productData?.unit}",
              style: PasarAjaTypography.sfpdRegular.copyWith(fontSize: 25),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: product.checked,
                  onChanged: (status) {

                  },
                ),
                SizedBox(
                  width: 100,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: product.productData?.photo ?? '',
                      placeholder: (context, str) {
                        return const ImageNetworkPlaceholder();
                      },
                      errorWidget: (context, str, obj) {
                        return const ImageErrorNetwork();
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () {
                      product.quantity = ((product.quantity ?? 0) - 1);
                    },
                    icon: const Icon(Icons.exposure_minus_1)),
                // Add TextField here
                const SizedBox(
                  width: 60,
                  height: 40,
                  child: TextField(
                    // controller: provider.quantityCont,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      product.quantity = ((product.quantity ?? 0) + 1);
                    },
                    icon: const Icon(Icons.exposure_plus_1_outlined)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Harga : Rp. (${PasarAjaUtils.formatPrice((product.productData?.price ?? 0) * (product.quantity ?? 0))})",
              style: PasarAjaTypography.sfpdRegular.copyWith(fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}
