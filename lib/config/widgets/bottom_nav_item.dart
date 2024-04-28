import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

PersistentBottomNavBarItem bottomNavItem({
  required String itemName,
  dynamic Function(dynamic o)? onPressed,
  Icon? activeIcon,
  Icon? inactiveIcon,
}) {
  return PersistentBottomNavBarItem(
    onPressed: onPressed,
    icon: activeIcon ?? const Icon(Icons.home),
    inactiveIcon: inactiveIcon ?? const Icon(Icons.home_outlined),
    iconSize: 28,
    title: itemName,
    textStyle: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 12.5),
    activeColorPrimary: PasarAjaColor.green1,
    inactiveColorPrimary: CupertinoColors.systemGrey,
  );
}

PersistentBottomNavBarItem bottomNavBarItemFloating({
  required String itemName,
  required dynamic Function(dynamic o)? onPressed,
  IconData? activeIcon,
  IconData? inactiveIcon,
}) {
  return PersistentBottomNavBarItem(
    onPressed: onPressed,
    icon: Icon(
      activeIcon ?? Icons.add,
      color: Colors.white,
    ),
    inactiveIcon: Icon(
      inactiveIcon,
      color: Colors.white,
    ),
    iconSize: 28,
    title: itemName,
    textStyle: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 12.5),
    activeColorPrimary: PasarAjaColor.gray1,
    inactiveColorPrimary: CupertinoColors.systemGrey,
  );
}
