import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/module/merchant/models/product/choose_categories_model.dart';

class ChooseCategory extends StatelessWidget {
  const ChooseCategory({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  final ChooseCategoriesModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blue.shade200,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: category.photo,
              placeholder: (context, url) {
                return const Text("Gambar");
              },
              errorWidget: (context, url, error) {
                return const Text("Error");
              },
            ),
          ),
          title: Text(
            category.categoryName,
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 16,
            ),
          ),
          trailing: Text(
            '${category.prodCount}',
            style: PasarAjaTypography.sfpdBold.copyWith(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
