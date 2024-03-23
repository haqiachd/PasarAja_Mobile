import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';

class PasarAjaAppbar extends StatelessWidget {
  final String? title;
  final Widget? action;

  const PasarAjaAppbar({
    super.key,
    this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.7,
      child: AppBar(
        toolbarHeight: 93 - MediaQuery.of(context).padding.top,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 22,
            right: 22,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title!,
                style: PasarAjaTypography.sfpdBold.copyWith(
                  fontSize: 24,
                  letterSpacing: -0.2,
                ),
              ),
              action ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
