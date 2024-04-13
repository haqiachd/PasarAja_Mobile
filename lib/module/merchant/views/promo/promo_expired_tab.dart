// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/providers/providers.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/empty_promo.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_promo.dart';
import 'package:provider/provider.dart';

class PromoExpiredTab extends StatefulWidget {
  const PromoExpiredTab({super.key});

  @override
  State<PromoExpiredTab> createState() => _PromoExpiredTabState();
}

class _PromoExpiredTabState extends State<PromoExpiredTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<PromoExpiredProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PromoExpiredProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<PromoExpiredProvider>(
        builder: (context, propider, child) {
          if (propider.state is OnLoadingState) {
            return const LoadingIndicator();
          }

          if (propider.state is OnFailureState) {
            return PageErrorMessage(
              onFailureState: propider.state as OnFailureState,
            );
          }

          if (propider.state is OnSuccessState) {
            final data = propider.promos;
            if (data.isNotEmpty) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final promo = data[index];
                  return ItemPromo(
                    promo: promo,
                    status: ItemPromo.expired,
                  );
                },
              );
            }
          } else {
            return const EmptyPromo(
              title: "Tidak Ada Promo yang Kadaluarsa",
            );
          }

          return const SomethingWrong();
        },
      ),
    );
  }
}
