import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ProdcutFeatureButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ProdcutFeatureButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: onPressed,
            style: const ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  side: BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: PasarAjaTypography.sfpdSemibold.copyWith(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
