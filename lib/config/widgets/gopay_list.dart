import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/widgets/even_title_model.dart';
import 'package:pasaraja_mobile/config/widgets/gopay_model.dart';
import 'package:pasaraja_mobile/config/widgets/event_title.dart';
import 'package:pasaraja_mobile/core/constants/gopay_data.dart';

class GoPayList extends StatelessWidget {
  final EventTitleModel? model;
  final List<GoPayModel>? list;

  const GoPayList({
    this.model,
    this.list,
  });

  @override
  Widget build(BuildContext context) {
    return EventTitle(
      model: EventTitleModel(
        icon: model!.icon,
        iconSize: model!.iconSize,
        title: model!.title,
        btnTitle: model!.btnTitle,
        deskripsi: model!.deskripsi,
        haveButton: model!.haveButton,
        contentSpace: model!.contentSpace,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 7.5),
              ...gopaylist.map(
                    (data) => Padding(
                  padding: const EdgeInsets.only(left: 7.5, right: 7.5),
                  child: Container(
                    width: 345,
                    height: 173,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        data.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7.5),
            ],
          ),
        ),
      ),
    );
  }
}
