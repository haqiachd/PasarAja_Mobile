import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ItemOtpView extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String pin)? onChanged;
  final double? width;
  final double? height;
  final bool? error;
  const ItemOtpView({
    super.key,
    this.controller,
    this.onChanged,
    this.width,
    this.height,
    this.error = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 49,
      height: height ?? 49,
      child: TextField(
        controller: controller,
        onChanged: (value) {},
        style: PasarAjaTypography.sfpdBold.copyWith(
          fontSize: 20,
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 1.5),
          enabledBorder: error == false ? _enabledBorder() : _errorBorder(),
          focusedBorder: error == false ? _focusedBorder() : _errorBorder(),
          errorBorder: _errorBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder _enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(
        color: PasarAjaColor.gray1,
        width: 1.5,
      ),
    );
  }
}

OutlineInputBorder _focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: const BorderSide(
      color: Colors.black,
      width: 1.5,
    ),
  );
}

OutlineInputBorder _errorBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: const BorderSide(
      color: Colors.red,
      width: 1.5,
    ),
  );
}
