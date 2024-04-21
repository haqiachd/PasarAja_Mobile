import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';

class PhotoProfile extends StatelessWidget {
  final VoidCallback? onTap;
  final String photoPath;

  const PhotoProfile({
    super.key,
    required this.photoPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            imageUrl: photoPath,
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
    );
  }
}
