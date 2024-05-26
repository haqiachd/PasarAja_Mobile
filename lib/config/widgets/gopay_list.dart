import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/even_title_model.dart';
import 'package:pasaraja_mobile/config/widgets/gopay_model.dart';
import 'package:pasaraja_mobile/config/widgets/event_title.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/constants/gopay_data.dart';
import 'package:pasaraja_mobile/module/customer/models/event_model.dart';
import 'package:pasaraja_mobile/module/customer/views/home/event_detail_page.dart';

class GoPayList extends StatelessWidget {
  final EventTitleModel? model;
  final List<EventModel>? list;

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
              ...list!.map(
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
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          EventDetailPage(
                            event: data,
                          ),
                          transition: Transition.cupertino,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: data.foto ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, s, d) {
                            return const ImageErrorNetwork();
                          },
                          placeholder: (context, j) {
                            return const ImageNetworkPlaceholder();
                          },
                        ),
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
