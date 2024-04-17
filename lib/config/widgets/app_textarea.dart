import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';

class AppTextArea extends StatelessWidget {
  const AppTextArea({
    Key? key,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.formatters,
    this.obscureText,
    this.showHelper,
    this.readOnly,
    this.maxLength,
    this.maxLines,
    this.fontSize,
    this.hintText,
    this.errorText,
    this.suffixIcon,
    this.suffixAction,
    this.showCounter,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? formatters;
  final Iterable<String>? autofillHints;
  final bool? obscureText;
  final bool? showHelper;
  final bool? readOnly;
  final int? maxLines;
  final int? maxLength;
  final double? fontSize;
  final String? hintText;
  final String? errorText;
  final Widget? suffixIcon;
  final VoidCallback? suffixAction;
  final bool? showCounter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines ?? 5,
      readOnly: readOnly ?? false,
      style: PasarAjaTypography.sfpdBoldAuthInput.copyWith(
        color: PasarAjaColor.black,
        fontSize: fontSize,
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
        counterStyle: showCounter ?? false
            ? PasarAjaTypography.sfpdSemibold
            : const TextStyle(color: Colors.transparent),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 7.5,
          vertical: 4.7,
        ),
        hintText: hintText,
        hintStyle: PasarAjaTypography.sfpdBoldAuthInput.copyWith(
          color: PasarAjaColor.gray5,
          fontSize: fontSize,
        ),
        enabledBorder: _enabledBorder(),
        focusedBorder: _focusedBorder(),
        errorBorder: _errorBorder(),
        errorText: (showHelper ?? true) ? _errorBuilder(errorText) : null,
        errorStyle: PasarAjaTypography.sfpdAuthHelper,
        suffixIcon: controller.text.isNotEmpty
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
}

String? _errorBuilder(String? errMessage) {
  if (errMessage == null) {
    return null;
  }

  if (errMessage == '') {
    return null;
  }

  if (errMessage == 'Data valid' || errMessage.contains('null')) {
    return null;
  }

  return errMessage;
}

OutlineInputBorder _enabledBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: PasarAjaColor.gray3,
      width: 1.7,
    ),
  );
}

OutlineInputBorder _focusedBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: PasarAjaColor.gray3,
      width: 1.5,
    ),
  );
}

OutlineInputBorder _errorBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: PasarAjaColor.red1,
      width: 1.8,
    ),
  );
}
