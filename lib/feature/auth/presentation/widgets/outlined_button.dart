import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';

class AuthOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;
  final double? width;
  final double? height;
  const AuthOutlinedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 330,
      height: height ?? 43,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          side: const MaterialStatePropertyAll(
            BorderSide(
              width: 1.8,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            PasarAjaColor.white,
          ),
          foregroundColor: MaterialStateProperty.all(
            PasarAjaColor.green2,
          ),
          overlayColor: MaterialStateProperty.all(
            PasarAjaColor.green2.withOpacity(0.1),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        child: Text(
          title ?? '[button]',
          style: const TextStyle(
            // Sesuaikan dengan gaya teks yang diinginkan
            color: PasarAjaColor.green2, // Ubah ke warna yang sesuai
            fontSize: 16, // Ubah ke ukuran font yang diinginkan
            fontWeight: FontWeight
                .bold, // Sesuaikan dengan ketebalan font yang diinginkan
          ),
        ),
      ),
    );
  }
}
