import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_product_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.product,
    required this.onCheckboxChanged,
    required this.onTapQty,
    required this.onPlusOneCart,
    required this.onMinusOneCart,
    required this.onSaveChanges,
    required this.onAddNotes,
    required this.onDeleteProduct,
  }) : super(key: key);

  final CartProductModel product;
  final void Function(bool?) onCheckboxChanged;
  final void Function() onTapQty;
  final void Function() onPlusOneCart;
  final void Function() onMinusOneCart;
  final void Function() onSaveChanges;
  final void Function() onAddNotes;
  final void Function() onDeleteProduct;

  @override
  Widget build(BuildContext context) {
    // initialize total price
    final int initTotalPrice =
        PasarAjaUtils.isActivePromo(product.productData!.promo!)
            ? (product.productData!.promo!.promoPrice! *
                    (product.quantity ?? 0))
                .toInt()
            : (product.productData!.price! * (product.quantity ?? 0)).toInt();
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
        PasarAjaUtils.isActivePromo(product.productData?.promo)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Rp. ${PasarAjaUtils.formatPrice(product.productData?.price ?? 0)}",
                    style: PasarAjaTypography.sfpdRegular.copyWith(
                      fontSize: 20,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    "Rp. ${PasarAjaUtils.formatPrice(product.productData?.promo?.promoPrice ?? 0)} / ${product.productData?.sellingUnit} ${product.productData?.unit}",
                    style:
                        PasarAjaTypography.sfpdRegular.copyWith(fontSize: 20),
                  ),
                  Text(
                    "Dis : ${product.productData?.promo?.percentage} %",
                    style:
                        PasarAjaTypography.sfpdRegular.copyWith(fontSize: 16),
                  ),
                ],
              )
            : Text(
                "Rp. ${PasarAjaUtils.formatPrice(product.productData?.price ?? 0)} / ${product.productData?.sellingUnit} ${product.productData?.unit}",
                style: PasarAjaTypography.sfpdRegular.copyWith(fontSize: 25),
              ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: product.checked,
              onChanged: onCheckboxChanged,
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
                onPressed: onMinusOneCart,
                icon: const Icon(Icons.exposure_minus_1)),
            // Add TextField here
            SizedBox(
              width: 100,
              height: 40,
              child: TextField(
                controller: product.controller ??
                    TextEditingController(text: '${product.quantity}'),
                showCursor: false,
                onTap: onTapQty,
                readOnly: true,
                textAlign: TextAlign.center,
                style: PasarAjaTypography.sfpdSemibold,
                keyboardType: TextInputType.number,
                inputFormatters: AppTextField.numberFormatter(),
                decoration: const InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
                onPressed: onPlusOneCart,
                icon: const Icon(Icons.exposure_plus_1_outlined)),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "Rp. ${PasarAjaUtils.formatPrice(product.totalPrice ?? initTotalPrice)}",
          style: PasarAjaTypography.sfpdRegular.copyWith(fontSize: 20),
        ),
        const SizedBox(width: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: product.onChages ?? false,
              child: IconButton(
                onPressed: onSaveChanges,
                icon: const Icon(Icons.upload),
                tooltip: 'Save',
              ),
            ),
            IconButton(
              onPressed: onAddNotes,
              icon: Icon(
                Icons.note_add_sharp,
                color: (product.notes != null &&
                        product.notes!.isNotEmpty &&
                        product.notes!.trim().isNotEmpty)
                    ? Colors.green.shade700
                    : Colors.blueGrey.shade800,
              ),
              tooltip: 'catatan',
            ),
            IconButton(
              onPressed: onDeleteProduct,
              tooltip: 'hapus',
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}
