import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';

class PasarAjaTypography {
  static const TextStyle sfProDisplay = TextStyle(fontFamily: 'SF-Pro-Display');

  static TextStyle sfpdRegular = sfProDisplay.copyWith(
    fontWeight: FontWeight.w400,
  );

  static TextStyle sfpdAuthDescription = sfpdRegular.copyWith(
    color: PasarAjaColor.gray1,
    height: 1.2,
    fontSize: 16,
  );

  static TextStyle sfpdMedium = sfProDisplay.copyWith(
    fontWeight: FontWeight.w500,
  );

  static TextStyle sfpdAuthInputTitle = sfpdSemibold.copyWith(
    color: Colors.black,
    fontSize: 12,
  );

  static TextStyle sfpdAuthHelper = sfProDisplay.copyWith(
    fontSize: 12,
    color: PasarAjaColor.red1,
  );

  static TextStyle sfpdSemibold = sfProDisplay.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle sfpdRightText = sfpdSemibold.copyWith(
    color: PasarAjaColor.gray1,
    fontSize: 12,
  );

  static TextStyle sfpdAuthFilledButton = sfpdSemibold.copyWith(
    color: Colors.white,
    fontSize: 15,
  );

  static TextStyle sfpdOtp = sfProDisplay.copyWith(
    fontSize: 23,
    color: PasarAjaColor.black,
  );

  static TextStyle sfpdBold = sfProDisplay.copyWith(
    fontWeight: FontWeight.w700,
  );

  static TextStyle sfpdBoldAuthInput = sfpdBold.copyWith(
    fontSize: 23,
  );

  static TextStyle sfpdAuthTitle = sfpdBold.copyWith(
    color: Colors.black,
    fontSize: 24,
  );

  static TextStyle sfpdBold_30 = sfpdBold.copyWith(
    fontSize: 30,
    letterSpacing: 1.5,
  );
}
