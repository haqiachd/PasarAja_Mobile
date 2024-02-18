import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class ItemOtpView extends StatelessWidget {
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final bool? error;
  final bool? obscureText;
  final bool? first;
  final bool? last;
  const ItemOtpView({
    super.key,
    this.controller,
    this.width,
    this.height,
    this.error = false,
    this.obscureText = false,
    this.first = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }

          if (value.length != 1 && first == false) {
            FocusScope.of(context).previousFocus();
          }
          setState() {}
        },
        autofocus: true,
        showCursor: false,
        readOnly: false,
        obscureText: obscureText ?? false,
        obscuringCharacter: "•",
        style: PasarAjaTypography.sfpdOtp,
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
        color: PasarAjaColor.gray3,
        width: 1.5,
      ),
    );
  }
}

OutlineInputBorder _focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: const BorderSide(
      color: PasarAjaColor.gray4,
      width: 2,
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
