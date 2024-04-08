import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';

class ImageNetworkPlaceholder extends StatelessWidget {
  const ImageNetworkPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: PasarAjaColor.gray4,
      child: Center(
        child: CupertinoActivityIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
