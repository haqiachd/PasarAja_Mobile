import 'package:flutter/material.dart';

class PasarAjaFont {
  static const TextStyle sfProDisplay = TextStyle(fontFamily: 'SF-Pro-Display');

  static TextStyle sfpdRegular = sfProDisplay.copyWith(
    fontWeight: FontWeight.w400,
  );

  static TextStyle sfpdMedium = sfProDisplay.copyWith(
    fontWeight: FontWeight.w500,
  );

  static TextStyle sfpdSemibold = sfProDisplay.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle sfpdBold = sfProDisplay.copyWith(
    fontWeight: FontWeight.w700,
  );

  static TextStyle sfpdBold_30 = sfpdBold.copyWith(
    fontSize: 30,
    letterSpacing: 1.5,
  );
}
