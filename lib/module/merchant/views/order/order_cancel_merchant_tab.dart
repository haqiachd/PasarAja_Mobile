import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/providers.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_detail_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/empty_order.dart';
import 'package:provider/provider.dart';

class OrderCancelMerchant extends StatefulWidget {
  const OrderCancelMerchant({super.key});

  @override
  State<OrderCancelMerchant> createState() => _OrderCancelMerchantState();
}

class _OrderCancelMerchantState extends State<OrderCancelMerchant> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<OrderCancelMerchantProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderCancelMerchantProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<OrderCancelMerchantProvider>(
        builder: (context, order, child) {
          if (order.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (order.state is OnFailureState) {
            return PageErrorMessage(
              onFailureState: order.state as OnFailureState,
            );
          }

          if (order.state is OnSuccessState) {
            List<TransactionModel> orders = order.orders;
            if (orders.isNotEmpty) {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  TransactionModel order = orders[index];
                  return _itemOrder(order);
                },
              );
            } else {
              return const EmptyOrder(
                "Belum ada Pesanan yang Dibatalkan Penjual",
              );
            }
          }

          return const SomethingWrong();
        },
      ),
    );
  }

  _itemOrder(TransactionModel order) {
    return InkWell(
      onTap: () {
        Get.to(
          OrderDetailPage(
            orderCode: order.orderCode ?? '',
            provider: OrderCancelMerchantProvider(),
          ),
          transition: Transition.cupertino,
          duration: PasarAjaConstant.transitionDuration,
        );
      },
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              order.orderId ?? '',
              style: PasarAjaTypography.sfpdBold.copyWith(
                color: Colors.blue,
                fontSize: 22,
              ),
            ),
            Text(
              order.fullName ?? '',
              style: PasarAjaTypography.sfpdBold,
            ),
            Text(
              "${order.details?.length ?? 0} x product",
              style: PasarAjaTypography.sfpdSemibold,
            ),
            const Text("_"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: order.details!
                  .map(
                    (prod) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${prod.quantity} x ${prod.productName}",
                          style: PasarAjaTypography.sfpdRegular,
                        ),
                        Text(
                          "Rp. ${PasarAjaUtils.formatPrice(prod.price ?? 0)}",
                          style: PasarAjaTypography.sfpdRegular,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const Text("_"),
            Text(
              "${order.totalQuantity} Produk",
              style: PasarAjaTypography.sfpdBold,
            ),
            Text(
              "Rp. ${PasarAjaUtils.formatPrice(order.subTotal ?? 0)}",
              style: PasarAjaTypography.sfpdBold,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
