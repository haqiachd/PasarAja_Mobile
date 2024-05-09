import 'package:flutter/material.dart';

class EventTitleModel {
  String? icon;
  double iconSize;
  String? title;
  String? btnTitle;
  String? deskripsi;
  bool haveButton;
  Widget? child;
  double contentSpace;

  EventTitleModel({
    this.icon,
    this.iconSize = 21,
    this.title,
    this.btnTitle,
    this.deskripsi,
    this.haveButton = false,
    this.child,
    this.contentSpace = 20,
  });
}
