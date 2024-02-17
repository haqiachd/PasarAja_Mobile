import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_description.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_image.dart';
import 'package:pasaraja_mobile/feature/auth/presentation/widgets/auth_title.dart';

class AuthInit extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  const AuthInit({
    super.key,
    required this.image,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthImage(image: image),
        const SizedBox(height: 19),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthTitle(title: title),
            const SizedBox(height: 5),
            AuthDescription(description: description),
          ],
        )
      ],
    );
  }
}
