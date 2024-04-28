import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_history_model.dart';
import 'package:pasaraja_mobile/module/customer/views/order/order_detail_page.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:pasaraja_mobile/module/customer/widgets/empty_order.dart';
import 'package:pasaraja_mobile/module/customer/widgets/order_reject.dart';
import 'package:provider/provider.dart';

class OrderRequestTab extends StatefulWidget {
  const OrderRequestTab({Key? key}) : super(key: key);

  @override
  State<OrderRequestTab> createState() => _OrderRequestTabState();
}

class _OrderRequestTabState extends State<OrderRequestTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<CustomerOrderRequestProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CustomerOrderRequestProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<CustomerOrderRequestProvider>(
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
            List<TransactionHistoryModel> orders = order.orders;
            if (orders.isNotEmpty) {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  TransactionHistoryModel order = orders[index];
                  return _itemOrder(order);
                },
              );
            } else {
              return const EmptyOrder("Belum ada Pesanan yang Dikonfirmasi");
            }
          }

          return const SomethingWrong();
        },
      ),
    );
  }

  _itemOrder(TransactionHistoryModel order) {
    return InkWell(
      onTap: () {
        Get.to(
          OrderDetailPage(
            orderCode: order.orderCode ?? '',
            provider: CustomerOrderRequestProvider(),
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
              order.shopData?.shopName ?? '',
              style: PasarAjaTypography.sfpdBold,
            ),
            Text(
              "${order.details?.length ?? 0} x Produk",
              style: PasarAjaTypography.sfpdSemibold,
            ),
            const Text("_"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: order.details!
                  .map(
                    (detail) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${detail.quantity} x ${detail.product?.productName ?? 'null'}",
                          style: PasarAjaTypography.sfpdRegular,
                        ),
                        Text(
                          "Rp. ${PasarAjaUtils.formatPrice(detail.subTotal ?? 0)}",
                          style: PasarAjaTypography.sfpdRegular,
                        ),
                        Visibility(
                          visible: detail.notes != null &&
                              detail.notes!.trim().isNotEmpty,
                          child: Text(
                            "Notes : ${detail.notes ?? ''}",
                            style: PasarAjaTypography.sfpdRegular,
                          ),
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
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildButtonCancel(order),
                const SizedBox(height: 10),
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  _buildButtonCancel(TransactionHistoryModel data) {
    return Consumer<CustomerOrderRequestProvider>(
      builder: (context, order, child) {
        return OrderReject(
          title: 'Batalkan',
          onPressed: () {
            order.onButtonCancelPressed(
              idShop: data.shopData?.idShop ?? 0,
              orderCode: data.orderCode ?? '',
            );
          },
        );
      },
    );
  }
}
