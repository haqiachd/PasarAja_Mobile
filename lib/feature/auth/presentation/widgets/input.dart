import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      style: PasarAjaTypography.sfpdBoldAuthInput.copyWith(
        color: PasarAjaColor.black,
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      obscureText: false,
      cursorColor: PasarAjaColor.purple1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        hintText: '85-xxxx-xxxx',
        hintStyle: PasarAjaTypography.sfpdBoldAuthInput.copyWith(
          color: PasarAjaColor.gray5,
        ),
        enabledBorder: _defBorder(),
        focusedBorder: _defBorder(),
        errorBorder: _errorBorder(),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.clear),
        ),
      ),
    );
  }
}

UnderlineInputBorder _defBorder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(
      color: PasarAjaColor.gray3,
      width: 1.5,
    ),
  );
}

UnderlineInputBorder _errorBorder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(
      color: PasarAjaColor.red1,
      width: 2,
    ),
  );
}
