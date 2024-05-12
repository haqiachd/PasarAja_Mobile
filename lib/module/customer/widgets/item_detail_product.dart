import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/buat_bintang.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/order/order_finished_provider.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_complain_page.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_review_page.dart';

class ItemDetailProduct extends StatelessWidget {
  const ItemDetailProduct({
    super.key,
    required this.state,
    required this.prod,
    required this.orderCode,
    required this.idTrx,
    required this.onDeleteReview,
    required this.onDeleteComplain,
  });

  final TransactionDetailHistoryModel prod;
  final ChangeNotifier state;
  final String orderCode;
  final int idTrx;
  final void Function() onDeleteReview;
  final void Function() onDeleteComplain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  placeholder: (context, url) {
                    return const ImageNetworkPlaceholder();
                  },
                  errorWidget: (context, url, error) {
                    return const ImageErrorNetwork();
                  },
                  imageUrl: prod.product?.photo ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${prod.quantity} x ${prod.product?.productName}",
                    style: PasarAjaTypography.sfpdRegular.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Rp. ${PasarAjaUtils.formatPrice(prod.subTotal ?? 0)}",
                    style: PasarAjaTypography.sfpdRegular.copyWith(
                      fontSize: 16,
                      decoration: (prod.promoPrice ?? 0) > 0
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  Visibility(
                    visible: (prod.promoPrice ?? 0) > 0,
                    child: Text(
                      "Rp. ${PasarAjaUtils.formatPrice(prod.totalPrice ?? 0)}",
                      style: PasarAjaTypography.sfpdRegular.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: prod.notes != null && prod.notes!.trim().isNotEmpty,
          child: Text(
            "Notes : ${prod.notes ?? ''}",
            maxLines: 3,
            softWrap: true,
            style: PasarAjaTypography.sfpdRegular.copyWith(
              overflow: TextOverflow.ellipsis,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Divider(),
        const SizedBox(height: 5),
        (prod.review?.star ?? '0') != '0'
            ? MyReview(
                state: state,
                prod: prod,
                idTrx: idTrx,
                onDeleteReview: onDeleteReview,
              )
            : EmptyReview(
                state: state,
                prod: prod,
                orderCode: orderCode,
              ),
        const SizedBox(height: 5),
        const Divider(),
        const SizedBox(height: 5),
        (prod.complain?.reason ?? '') != ''
            ? MyComplain(
                state: state,
                prod: prod,
                idTrx: idTrx,
                onDeleteComplain: onDeleteComplain,
              )
            : EmptyComplain(
                state: state,
                prod: prod,
                orderCode: orderCode,
              ),
        const Divider(),
      ],
    );
  }
}

class MyReview extends StatelessWidget {
  const MyReview({
    super.key,
    required this.state,
    required this.prod,
    required this.idTrx,
    required this.onDeleteReview,
  });

  final ChangeNotifier state;
  final TransactionDetailHistoryModel? prod;
  final int idTrx;
  final void Function() onDeleteReview;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: state is CustomerOrderFinishedProvider,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Ulasan Anda',
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: gaweBintang(int.parse(prod!.review?.star ?? '0')),
          ),
          const SizedBox(height: 10),
          Text(
            'Komentar : ',
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            prod!.review?.comment ?? 'null',
            style: PasarAjaTypography.sfpdRegular.copyWith(
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    prod!.review?.updatedAt
                            ?.toIso8601String()
                            .substring(0, 10) ??
                        'null',
                    style: PasarAjaTypography.sfpdSemibold.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.off(
                    OrderReviewPage(
                      prod: prod!,
                      isEdit: true,
                      star: int.parse(prod!.review!.star!),
                      idTrx: idTrx,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Text(
                  'Edit',
                  style: PasarAjaTypography.sfpdSemibold.copyWith(
                    fontSize: 15,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: onDeleteReview,
                child: Text(
                  'Hapus',
                  style: PasarAjaTypography.sfpdSemibold.copyWith(
                    fontSize: 15,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class MyComplain extends StatelessWidget {
  const MyComplain({
    super.key,
    required this.state,
    required this.prod,
    required this.idTrx,
    required this.onDeleteComplain,
  });

  final ChangeNotifier state;
  final TransactionDetailHistoryModel? prod;
  final int idTrx;
  final void Function() onDeleteComplain;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: state is CustomerOrderFinishedProvider,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Komplain Anda',
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Alasan : ',
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            prod!.complain?.reason ?? 'null',
            style: PasarAjaTypography.sfpdRegular.copyWith(
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    prod!.complain?.updatedAt
                            ?.toIso8601String()
                            .substring(0, 10) ??
                        'null',
                    style: PasarAjaTypography.sfpdSemibold.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.off(
                    OrderComplainPage(
                      prod: prod!,
                      isEdit: true,
                      idTrx: idTrx,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Text(
                  'Edit',
                  style: PasarAjaTypography.sfpdSemibold.copyWith(
                    fontSize: 15,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: onDeleteComplain,
                child: Text(
                  'Hapus',
                  style: PasarAjaTypography.sfpdSemibold.copyWith(
                    fontSize: 15,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class EmptyReview extends StatelessWidget {
  const EmptyReview({
    super.key,
    required this.state,
    required this.prod,
    required this.orderCode,
  });

  final ChangeNotifier state;
  final TransactionDetailHistoryModel prod;
  final String orderCode;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: state is CustomerOrderFinishedProvider,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Beri Ulasan Produk',
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 5; i++)
                InkWell(
                  onTap: () {
                    Get.off(
                      OrderReviewPage(
                        prod: prod,
                        isEdit: false,
                        star: ++i,
                        orderCode: orderCode,
                      ),
                      transition: Transition.rightToLeft,
                    );
                  },
                  splashColor: Colors.transparent,
                  child: Icon(
                    Icons.star_border,
                    size: Get.width / 10,
                    color: Colors.orange,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyComplain extends StatelessWidget {
  const EmptyComplain({
    super.key,
    required this.state,
    required this.prod,
    required this.orderCode,
  });

  final ChangeNotifier state;
  final TransactionDetailHistoryModel prod;
  final String orderCode;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: state is CustomerOrderFinishedProvider,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Get.off(
                OrderComplainPage(
                  prod: prod,
                  isEdit: false,
                  orderCode: orderCode,
                ),
                transition: Transition.rightToLeft,
              );
            },
            child: Text(
              'Laporkan Masalah?',
              style: PasarAjaTypography.sfpdSemibold.copyWith(
                fontSize: 15,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
