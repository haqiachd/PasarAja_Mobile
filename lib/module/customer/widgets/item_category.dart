import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/module/customer/models/product_categories_model.dart';

class CusItemCategory extends StatelessWidget {
  const CusItemCategory({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  final ProductCategoryModel category;
  final VoidCallback onTap;
  final selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 1, right: 1),
        child: SizedBox(
          height: 200,
          width: 100,
          child: Material(
            color:
            selected ? PasarAjaColor.green1.withOpacity(0.2) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors
                      .transparent, // Set the background color to transparent
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: category.photo ?? '',
                      placeholder: (context, url) {
                        return Image.asset(PasarAjaImage.icGoogle);
                      },
                      errorWidget: (context, url, error) {
                        return const Text('error');
                      },
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                Text(
                  category.categoryName ?? 'null',
                  textAlign: TextAlign.center,
                  style: PasarAjaTypography.sfpdBold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
