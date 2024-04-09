import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/providers.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/empty_order.dart';
import 'package:provider/provider.dart';

class OrderRequestTab extends StatefulWidget {
  const OrderRequestTab({super.key});

  @override
  State<OrderRequestTab> createState() => _OrderRequestTabState();
}

class _OrderRequestTabState extends State<OrderRequestTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<OrderRequestProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderRequestProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<OrderRequestProvider>(
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
            // jika data order tidak kosong
            if (orders.isNotEmpty) {
              return ListView(
                children: [
                  Center(
                    child: Text(
                      'Order Request',
                      style: PasarAjaTypography.sfpdBold.copyWith(
                        fontSize: 25,
                        color: PasarAjaColor.green1,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return ListView(
                children: const [
                  // SizedBox(height: 100),
                  EmptyOrder('Belum ada Permintaan Pesanan'),
                ],
              );
            }
          }

          return const SomethingWrong();
        },
      ),
    );
  }
}
