import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';

class ItemPromo extends StatelessWidget {
  const ItemPromo({
    super.key,
    required this.promo,
    required this.status,
  });

  final PromoModel promo;
  final int status;

  static int soon = 1;
  static int active = 2;
  static int expired = 3;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 100,
        height: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: promo.photo ?? '',
            placeholder: (context, url) {
              return const ImageNetworkPlaceholder();
            },
            errorWidget: (context, url, error) {
              return const ImageErrorNetwork();
            },
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            promo.productName ?? '',
            style: PasarAjaTypography.sfpdBold.copyWith(
              fontSize: 19,
            ),
          ),
          Text(
            promo.categoryProd ?? '',
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            "Rp.${PasarAjaUtils.formatPrice(promo.price ?? 0)}",
            style: PasarAjaTypography.sfProDisplay.copyWith(
              decoration: TextDecoration.lineThrough,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                "Rp.${PasarAjaUtils.formatPrice(promo.promoPrice ?? 0)}",
                style: PasarAjaTypography.sfProDisplay.copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "(${promo.percentage})%",
                style: PasarAjaTypography.sfProDisplay.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                promo.startDate!.toIso8601String().substring(0, 10),
                style: PasarAjaTypography.sfpdSemibold.copyWith(
                  fontSize: 13,
                ),
              ),
              const Text(" - "),
              Text(
                promo.endDate!.toIso8601String().substring(0, 10),
                style: PasarAjaTypography.sfpdSemibold.copyWith(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Material(
            color: _statusColor(status),
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                _statusText(status),
                style: PasarAjaTypography.sfpdSemibold.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(int status) {
  switch (status) {
    case 1:
      return Colors.blueGrey;
    case 2:
      return Colors.blue;
    case 3:
      return Colors.red;
    default:
      return Colors.black;
  }
}

String _statusText(int status) {
  switch (status) {
    case 1:
      return "Akan Datang";
    case 2:
      return "Sedang Aktif";
    case 3:
      return "Kadaluarsa";
    default:
      return "Ga Tau";
  }
}
