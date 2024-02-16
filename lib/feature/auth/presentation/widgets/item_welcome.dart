import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_description.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_image.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_title.dart';

class ItemWelcome extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  const ItemWelcome({
    super.key,
    required this.image,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          AuthImage(image: image),
          const SizedBox(height: 27),
          AuthTitle(title: title),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: AuthDescription(description: description),
          ),
        ],
      ),
    );
  }
}
