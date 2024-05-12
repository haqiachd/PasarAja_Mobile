import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Widget> gaweBintang(int numberOfStars) {
  List<Widget> starIcons = [];
  for (int i = 0; i < 5; i++) {
    if (i < numberOfStars) {
      starIcons.add(
        Icon(
          Icons.star,
          size: Get.width / 10,
          color: Colors.orange,
        ),
      );
    } else {
      starIcons.add(
        Icon(
          Icons.star_border,
          size: Get.width / 10,
          color: Colors.orange,
        ),
      );
    }
  }
  return starIcons;
}