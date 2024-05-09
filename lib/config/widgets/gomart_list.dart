import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/even_title_model.dart';
import 'package:pasaraja_mobile/config/widgets/event_title.dart';
import 'package:pasaraja_mobile/config/widgets/gomar_model.dart';

class GomartList extends StatelessWidget {
  final EventTitleModel? eventTitle;
  final List<GoMartModel>? list;
  const GomartList({this.eventTitle, this.list});

  @override
  Widget build(BuildContext context) {
    return EventTitle(
      model: EventTitleModel(
        icon: eventTitle!.icon,
        iconSize: eventTitle!.iconSize,
        title: eventTitle!.title,
        btnTitle: eventTitle!.btnTitle,
        deskripsi: eventTitle!.deskripsi,
        haveButton: eventTitle!.haveButton,
        contentSpace: eventTitle!.contentSpace,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 12.5),
              ...list!.map(
                    (data) => Padding(
                  padding: const EdgeInsets.only(
                    left: 7.5,
                    right: 7.5,
                  ),
                  child: Container(
                    width: 145,
                    height: 213,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border(
                        top: BorderSide(
                            width: 0.7, color: PasarAjaColor.hex_E8E8E8),
                        left: BorderSide(
                            width: 1.3, color: PasarAjaColor.hex_E8E8E8),
                        right: BorderSide(
                            width: 1.3, color: PasarAjaColor.hex_E8E8E8),
                        bottom: BorderSide(
                            width: 2.4, color: PasarAjaColor.hex_E8E8E8),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 145,
                          height: 155,
                          child: Center(
                            child: Image.asset(
                              data.icon!,
                              width: data.iconWidth,
                              height: data.iconHeight,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9, right: 9),
                          child: Text(
                            data.title!,
                            style: PasarAjaTypography.bold16
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.5),
            ],
          ),
        ),
      ),
    );
  }
}
