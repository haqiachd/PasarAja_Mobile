import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/providers.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_cancel_page.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.orderCode,
    required this.provider,
  });

  final String orderCode;
  final ChangeNotifier? provider;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<OrderDetailProvider>().fetchData(
            orderCode: widget.orderCode,
          );
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: merchantSubAppbar("Detail Pesanan"),
      body: Consumer<OrderDetailProvider>(
        builder: (context, trx, child) {
          if (trx.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (trx.state is OnFailureState) {
            return PageErrorMessage(
              onFailureState: trx.state as OnFailureState,
            );
          }

          if (trx.state is OnSuccessState) {
            return SingleChildScrollView(
              child: _itemOrder(trx.order),
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }

  _itemOrder(TransactionModel order) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Order ID : ${order.orderId}",
            style: PasarAjaTypography.sfpdBold.copyWith(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "PIN Pesanan : ${order.orderPin}",
            style: PasarAjaTypography.sfpdBold.copyWith(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
          const Text("_"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: order.details!
                .map(
                  (prod) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                placeholder: (context, url) {
                                  return const ImageNetworkPlaceholder();
                                },
                                errorWidget: (context, url, error) {
                                  return const ImageErrorNetwork();
                                },
                                imageUrl: prod.productPhoto ?? '',
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
                                  "${prod.quantity} x ${prod.productName}",
                                  style:
                                      PasarAjaTypography.sfpdRegular.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Rp. ${PasarAjaUtils.formatPrice(prod.subTotal ?? 0)}",
                                  style:
                                      PasarAjaTypography.sfpdRegular.copyWith(
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
                                    style:
                                        PasarAjaTypography.sfpdRegular.copyWith(
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
                        visible:
                            prod.notes != null && prod.notes!.trim().isNotEmpty,
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
                      const SizedBox(height: 10),
                      const Divider(),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    placeholder: (context, url) {
                      return const ImageNetworkPlaceholder();
                    },
                    errorWidget: (context, url, error) {
                      return const ImageErrorNetwork();
                    },
                    imageUrl: order.userData?.photo ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    order.userData?.fullName ?? '',
                    style: PasarAjaTypography.sfpdBold.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    order.userData?.email ?? '',
                    style: PasarAjaTypography.sfpdBold.copyWith(
                      fontSize: 15,
                      color: PasarAjaColor.gray4,
                    ),
                  ),
                  Text(
                    order.userData?.phoneNumber ?? '',
                    style: PasarAjaTypography.sfpdBold.copyWith(
                      fontSize: 15,
                      color: PasarAjaColor.gray4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          Text(
            "Sub Total : Rp. ${PasarAjaUtils.formatPrice(order.subTotal ?? 0)}",
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            "Total Promo : Rp. ${PasarAjaUtils.formatPrice(order.totalPromo ?? 0)}",
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            "Total Produk : ${order.totalProduct ?? 0}",
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            "Total Quantity : ${order.totalQuantity ?? 0}",
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            "Total Harga : Rp. ${PasarAjaUtils.formatPrice(order.totalPrice ?? 0)}",
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            "Tanggal Pesan : ${order.createdAt?.toIso8601String().substring(0, 10)}",
            style: PasarAjaTypography.sfpdSemibold.copyWith(
              fontSize: 14,
            ),
          ),
          const Text("_"),
          const Divider(),
          const SizedBox(height: 20),
          _buildSubmittedButton(order),
          _buildConfirmButton(order),
          const SizedBox(height: 10),
          _buildRejectButton(order),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  _buildConfirmButton(TransactionModel order) {
    if (widget.provider is OrderRequestProvider) {
      return Consumer<OrderDetailProvider>(
        builder: (context, prov, child) {
          return SizedBox(
            width: double.infinity,
            child: ActionButton(
              onPressed: () {
                prov.onButtonConfirmPressed(
                  orderCode: order.orderCode ?? '',
                  fullName: order.userData?.fullName ?? '',
                );
              },
              title:
                  "Konfirmasi Pesanan (Rp. ${PasarAjaUtils.formatPrice(order.totalPrice ?? 0)})",
              state: ActionButton.stateEnabledButton,
            ),
          );
        },
      );
    } else {
      return const Material();
    }
  }

  _buildSubmittedButton(TransactionModel order) {
    if (widget.provider is OrderInTakingProvider) {
      return Consumer<OrderInTakingProvider>(
        builder: (context, prov, child) {
          return SizedBox(
            width: double.infinity,
            child: ActionButton(
              onPressed: () {
                prov.onButtonSubmittedPressed(
                  orderCode: order.orderCode ?? '',
                  fullName: order.userData?.fullName ?? '',
                  orderId: order.orderId ?? '',
                );
              },
              title: "Serahkan Pesanan",
              state: ActionButton.stateEnabledButton,
            ),
          );
        },
      );
    } else {
      return const Material();
    }
  }

  _buildRejectButton(TransactionModel order) {
    if (widget.provider is OrderRequestProvider ||
        widget.provider is OrderConfirmedProvider) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            Get.off(
              OrderCancelPage(orderCode: order.orderCode ?? ''),
              transition: Transition.cupertino,
              duration: PasarAjaConstant.transitionDuration,
            );
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          child: const Text(
            'Batalkan Pesanan',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      return const Material();
    }
  }

//
}
