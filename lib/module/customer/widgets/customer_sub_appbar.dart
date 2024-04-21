import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

AppBar customerSubAppbar(String title) {
  return AppBar(
    backgroundColor: Colors.white,
    shadowColor: Colors.black,
    elevation: 1.5,
    centerTitle: true,
    title: Text(title, style: PasarAjaTypography.sfpdSemibold),
  );
}