import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ChooseButton extends StatelessWidget {
  final String? image;
  final String? title;
  final VoidCallback? onTap;
  const ChooseButton({
    super.key,
    this.image,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                image ?? PasarAjaIcon.icGoogle,
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 10),
              Text(
                title ?? '[title]',
                style: PasarAjaTypography.sfpdSemibold.copyWith(
                  fontSize: 14.5,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                PasarAjaIcon.icMoreThan,
              )
            ],
          ),
        ),
      ),
    );
  }
}
