import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';

AppBar authAppbar() {
  return AppBar(
    backgroundColor: PasarAjaColor.white,
    toolbarHeight: PasarAjaConstant.authTolbarHeight,
  );
}
