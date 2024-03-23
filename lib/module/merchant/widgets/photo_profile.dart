import 'package:flutter/material.dart';

class PhotoProfile extends StatelessWidget {
  final VoidCallback? onTap;
  const PhotoProfile({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const SizedBox(
        height: 50,
        width: 50,
        child: Material(
          color: Colors.blue,
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
