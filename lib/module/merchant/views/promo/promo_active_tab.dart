// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/lotties.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/providers/providers.dart';
import 'package:pasaraja_mobile/module/merchant/views/promo/detail_promo_page.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/empty_promo.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_promo.dart';
import 'package:provider/provider.dart';

class PromoActiveTab extends StatefulWidget {
  const PromoActiveTab({super.key});

  @override
  State<PromoActiveTab> createState() => _PromoActiveTabState();
}

class _PromoActiveTabState extends State<PromoActiveTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<PromoActiveProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PromoActiveProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<PromoActiveProvider>(
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
                  return InkWell(
                    onTap: () {
                      Get.to(
                        DetailPromoPage(
                          idPromo: promo.idPromo,
                        ),
                        transition: Transition.cupertino,
                      );
                    },
                    child: ItemPromo(
                      promo: promo,
                      status: ItemPromo.active,
                    ),
                  );
                },
              );
            } else {
              return ListView(
                children: const [
                  SizedBox(height: 100),
                  EmptyPromo(
                    title: "Tidak Ada Promo yang Sedang Aktif",
                  ),
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
