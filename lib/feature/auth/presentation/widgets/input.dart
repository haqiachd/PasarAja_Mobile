import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
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
      obscureText: true,
      cursorColor: PasarAjaColor.green1,
      cursorWidth: 2.5,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 7.5,
          vertical: 4.7,
        ),
        hintText: '85-xxxx-xxxx',
        hintStyle: PasarAjaTypography.sfpdBoldAuthInput.copyWith(
          color: PasarAjaColor.gray5,
        ),
        enabledBorder: _enabledBorder(),
        focusedBorder: _focusedBorder(),
        errorBorder: _errorBorder(),
        // errorText: 'Nomor Hp Tidak Valid',
        errorStyle: PasarAjaTypography.sfpdAuthHelper,
        suffixIcon: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            PasarAjaIcon.icClearText,
            width: 15,
            height: 15,
          ),
        ),
      ),
    );
  }
}

UnderlineInputBorder _enabledBorder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(
      color: PasarAjaColor.gray3,
      width: 1.7,
    ),
  );
}

UnderlineInputBorder _focusedBorder() {
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
      width: 1.8,
    ),
  );
}
