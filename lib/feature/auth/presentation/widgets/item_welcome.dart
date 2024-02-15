import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ItemWelcome extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  const ItemWelcome({super.key, this.image, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Image.asset(
            image ?? PasarAjaImage.ilConfirmPin,
            width: 348,
            height: 212,
          ),
          const SizedBox(height: 27),
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: PasarAjaTypography.sfpdAuthTitle,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Text(
              'Nikmati kemudahan berbelanja di pasar melalui aplikasi PasarAja, yang selalu siap membantu memenuhi semua kebutuhanmu.',
              textAlign: TextAlign.center,
              style: PasarAjaTypography.sfpdAuthDescription,
            ),
          ),
        ],
      ),
    );
  }
}
