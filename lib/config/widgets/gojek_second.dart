import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/icons.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/even_title_model.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/config/widgets/event_title.dart';
import 'package:pasaraja_mobile/module/customer/models/product_model.dart';
import 'package:pasaraja_mobile/module/customer/views/shopping/product_detail_page.dart';

class GoFoodSecond extends StatelessWidget {
  final EventTitleModel? eventTitle;
  final List<ProductModel>? models;

  const GoFoodSecond({
    required this.eventTitle,
    required this.models,
  });

  final double radius = 17;

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
                const SizedBox(width: 9),
                ...models!.map(
                  (data) => Container(
                    margin: const EdgeInsets.only(left: 9, right: 9),
                    width: 145,
                    height: 257,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radius),
                      border: Border(
                        top: BorderSide(
                            width: 0.1, color: PasarAjaColor.hex_E8E8E8),
                        left: BorderSide(
                            width: 1.3, color: PasarAjaColor.hex_E8E8E8),
                        right: BorderSide(
                            width: 1.3, color: PasarAjaColor.hex_E8E8E8),
                        bottom: BorderSide(
                            width: 2.4, color: PasarAjaColor.hex_E8E8E8),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          ProductDetailPage(
                            idShop: data.idShop!,
                            idProduct: data.id!,
                          ),
                          transition: Transition.cupertino,
                        );
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 145,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(radius),
                                topRight: Radius.circular(radius),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: data.photo ?? '',
                                height: 145,
                                fit: BoxFit.cover,
                                errorWidget: (context, s, d){
                                  return const ImageErrorNetwork();
                                },
                                placeholder: (context, j){
                                  return const ImageNetworkPlaceholder();
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 165, // 155
                            right: 10,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.productName ?? 'null',
                                  maxLines: 2,
                                  style: PasarAjaTypography.bold16.copyWith(
                                    color: Colors.black,
                                    height: 1.2,
                                  ),
                                ),
                                Text(
                                  "Rp. ${PasarAjaUtils.formatPrice(data.price ?? 0)}",
                                  maxLines: 1,
                                  style:
                                      PasarAjaTypography.regular12_5.copyWith(
                                    color: PasarAjaColor.hex_474948,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 20, // 10
                            left: 8,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  PasarAjaIcon.rating,
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(width: 9),
                                SizedBox(
                                  height: 15,
                                  child: Text(
                                    '${(data.rating! > 0.0 ? data.rating : 'N/A' )}   (${data.totalSold}) terjual',
                                    style: PasarAjaTypography.semibold12_5
                                        .copyWith(
                                      color: PasarAjaColor.hex_666867,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
              ],
            ),
          )),
    );
  }
}
