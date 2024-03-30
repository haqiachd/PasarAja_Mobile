import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_histories_model.dart';

class ItemHistory extends StatelessWidget {
  const ItemHistory({
    super.key,
    required this.history,
    this.showProduct = true,
  });

  final ProductHistoriesModel history;
  final bool showProduct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              imageUrl: history.photo ?? '',
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
          history.fullName ?? 'null',
          style: PasarAjaTypography.sfpdBold,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "(${history.quantity}) ~ ",
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  TextSpan(
                    text:
                        "Rp.${PasarAjaUtils.formatPrice(history.totalPrice ?? 0)}",
                  ),
                ],
              ),
            ),
            Text(history.takenDate!.toIso8601String().substring(0, 10))
          ],
        ),
      ),
    );
  }
}
