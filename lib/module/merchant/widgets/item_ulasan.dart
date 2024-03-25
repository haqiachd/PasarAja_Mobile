import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/module/merchant/models/review_model.dart';

class ItemUlasan extends StatelessWidget {
  const ItemUlasan({
    super.key,
    required this.review,
  });

  final ReviewModel review;

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
              imageUrl: review.photo ?? '',
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
          review.productName ?? 'null',
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
                    text: "Rating : ${review.star} ~ ",
                    style: PasarAjaTypography.sfpdSemibold,
                  ),
                  if (review.orderDate != null)
                    TextSpan(
                      text:
                          review.orderDate!.toIso8601String().substring(0, 10),
                      style: PasarAjaTypography.sfpdMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              "Komentar : ${review.comment}",
              style: PasarAjaTypography.sfpdRegular,
            ),
          ],
        ),
      ),
    );
  }
}
