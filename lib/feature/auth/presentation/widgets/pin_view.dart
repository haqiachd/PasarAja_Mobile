import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pinput/pinput.dart';

class AuthPin extends StatelessWidget {
  final TextEditingController? controller;
  final int? length;
  final double? width;
  final double? height;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;
  final void Function(String)? onSubmitted;
  final bool? obscureText;
  const AuthPin({
    super.key,
    this.controller,
    this.length,
    this.width,
    this.height,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: length ?? 4,
      showCursor: false,
      autofocus: false,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      onCompleted: onCompleted,
      onSubmitted: onSubmitted,
      defaultPinTheme: _pinTheme(),
      focusedPinTheme: _focusedPinTheme(),
      errorPinTheme: _errorPinTheme(),
      inputFormatters: [
        // LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: PasarAjaColor.gray4,
        width: 1.5,
      ),
    );
  }

  PinTheme _pinTheme() {
    return PinTheme(
      width: width ?? 49,
      height: height ?? 49,
      textStyle: PasarAjaTypography.sfpdOtp,
      decoration: _boxDecoration(),
    );
  }

  PinTheme _focusedPinTheme() {
    return _pinTheme().copyWith(
      decoration: _boxDecoration().copyWith(
        color: Colors.grey.withOpacity(0.2),
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
      ),
    );
  }

  PinTheme _errorPinTheme() {
    return _pinTheme().copyWith(
      decoration: _boxDecoration().copyWith(
        color: PasarAjaColor.white,
        border: Border.all(
          color: PasarAjaColor.red1,
          width: 1.5,
        ),
      ),
    );
  }
}
