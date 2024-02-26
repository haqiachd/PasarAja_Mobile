import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? formatters;
  final Iterable<String>? autofillHints;
  final bool? obscureText;
  final bool? isError;
  final int? maxLength;
  final String? hintText;
  final String? errorText;
  final Widget? suffixIcon;
  final VoidCallback? suffixAction;
  const AuthTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.formatters,
    this.obscureText,
    this.isError,
    this.maxLength,
    this.hintText,
    this.errorText,
    this.suffixIcon,
    this.suffixAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 1,
      style: PasarAjaTypography.sfpdBoldAuthInput.copyWith(
        color: PasarAjaColor.black,
      ),
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      obscureText: obscureText ?? false,
      cursorColor: PasarAjaColor.green1,
      cursorWidth: 2.5,
      inputFormatters: formatters,
      decoration: InputDecoration(
        counter: const Material(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 7.5,
          vertical: 4.7,
        ),
        hintText: hintText,
        hintStyle: PasarAjaTypography.sfpdBoldAuthInput.copyWith(
          color: PasarAjaColor.gray5,
        ),
        enabledBorder: _enabledBorder(),
        focusedBorder: isError ?? false ? _focusedBorder() : _errorBorder(),
        // errorText: (errorText != '' || errorText != 'valid') ? errorText : null,
        errorStyle: PasarAjaTypography.sfpdAuthHelper,
        suffixIcon: controller!.text.isNotEmpty
            ? IconButton(
                onPressed: suffixAction,
                icon: suffixIcon ??
                    SvgPicture.asset(
                      PasarAjaIcon.icClearText,
                    ),
              )
            : null,
      ),
    );
  }

  static List<TextInputFormatter> numberFormatter() {
    return [FilteringTextInputFormatter.digitsOnly];
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
