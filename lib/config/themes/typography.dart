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

  static TextStyle sfpdAuthHelper = sfpdSemibold.copyWith(
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

  /// SF Pro Display Font
  static final TextStyle primary = TextStyle(
    fontFamily: 'SF-Pro-Display',
  );

  /// SF Pro Display Regular 12.5
  static final TextStyle regular12_5 = primary.copyWith(
    fontSize: 12.5,
  );

  /// SF Pro Display Regular 14
  static final TextStyle regular14 = regular12_5.copyWith(
    fontSize: 14,
    letterSpacing: 0.4,
  );

  /// SF Pro Display Regular 14
  static final TextStyle regular14_line_spaccing_140 = regular12_5.copyWith(
    fontSize: 14.4,
    letterSpacing: 0.4,
  );

  /// SF Pro Display Semibold 11.5
  static final TextStyle semibold11_5 = primary.copyWith(
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
  );

  /// SF Pro Display Semibold 12.5
  static final TextStyle semibold12_5 = semibold11_5.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  /// SF Pro Display Semibold 14
  static final TextStyle semibold14 = semibold12_5.copyWith(
    fontSize: 14,
    letterSpacing: 0.1,
  );

  /// SF Pro Display Bold 14
  static final TextStyle bold14 = regular12_5.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    letterSpacing: 0.1,
  );

  /// SF Pro Display Bold 16
  static final TextStyle bold16 = bold14.copyWith(
    fontSize: 16,
  );

  /// SF Pro Display Bold 16
  static final TextStyle bold16_letter_spacing = bold16.copyWith(
    fontWeight: FontWeight.w700,
  );

  /// SF Pro Display Bold 18
  static TextStyle bold18 = bold16.copyWith(
    fontSize: 18,
    letterSpacing: -0.5,
  );

  /// SF Pro Display Bold 24
  static final TextStyle bold24 = bold18.copyWith(
    fontSize: 24,
    letterSpacing: -0.2,
  );
}
