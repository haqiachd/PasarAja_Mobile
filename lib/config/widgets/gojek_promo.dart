import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/gojek_promo_model.dart';

class GojekPromo extends StatelessWidget {
  final List<GojekPromoModel>? gojekPromo;
  const GojekPromo({this.gojekPromo});

  static double radius = 15;
  static double paddingText = 15;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...gojekPromo!.map(
              (data) => Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 26.133,
              right: MediaQuery.of(context).size.width / 26.133,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              border: Border(
                top: BorderSide(width: 0.5, color: PasarAjaColor.hex_E8E8E8),
                left: BorderSide(width: 1.2, color: PasarAjaColor.hex_E8E8E8),
                right: BorderSide(width: 1.2, color: PasarAjaColor.hex_E8E8E8),
                bottom: BorderSide(width: 3, color: PasarAjaColor.hex_E8E8E8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                  child: Image.asset(
                    data.image!,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height >=
                        MediaQuery.of(context).size.width
                        ? MediaQuery.of(context).size.width / 2.152
                        : MediaQuery.of(context).size.width / 4.576,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(
                    right: paddingText,
                    left: paddingText,
                  ),
                  child: Text(
                    data.title!,
                    style: PasarAjaTypography.bold16_letter_spacing.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: paddingText,
                    left: paddingText,
                  ),
                  child: Text(
                    data.deskripsi!,
                    style: PasarAjaTypography.regular14_line_spaccing_140.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
