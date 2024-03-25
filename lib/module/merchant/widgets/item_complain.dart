import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/module/merchant/models/complain_model.dart';

class ItemComplain extends StatelessWidget {
  const ItemComplain({
    super.key,
    required this.complain,
  });

  final ComplainModel complain;

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
              imageUrl: complain.userPhoto ?? '',
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
          complain.fullName ?? 'null',
          style: PasarAjaTypography.sfpdBold,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reason : ${complain.reason}",
              style: PasarAjaTypography.sfpdRegular,
            ),
            Text(
              "Date : ${complain.updatedAt!.toIso8601String().substring(0, 10)}",
              style: PasarAjaTypography.sfpdRegular,
            ),
          ],
        ),
      ),
    );
  }
}
