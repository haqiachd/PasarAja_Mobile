import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_description.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_image.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_title.dart';

class AuthInit extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  final bool? haveImage;
  const AuthInit({
    super.key,
    required this.image,
    required this.title,
    this.description,
    this.haveImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (haveImage == true) ? _image(image) : const Material(),
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

_image(String? image) {
  return Column(
    children: [
      AuthImage(image: image),
      const SizedBox(height: 19),
    ],
  );
}
