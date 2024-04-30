import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/customer/provider/providers.dart';
import 'package:provider/provider.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({Key? key}) : super(key: key);

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<CustomerShopProvider>().fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CustomerProductProvider>().onRefresh();
        await Future.delayed(
          Duration(seconds: PasarAjaConstant.onRefreshDelaySecond),
        );
        await _fetchData();
      },
      child: Consumer<CustomerShopProvider>(
          builder: (context, provider, child) {
            if (provider.state is OnLoadingState) {
              return const LoadingIndicator();
            }

            if (provider.state is OnFailureState) {
              return PageErrorMessage(
                onFailureState: provider.state as OnFailureState,
              );
            }

            if (provider.state is OnSuccessState) {
              var shops = provider.shops;
              return ListView.builder(
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  var shop = shops[index];
                  return ListTile(
                    title: Text(shop.shopName ?? 'null'),
                  );
                },
              );
            }

            return const SomethingWrong();
          },
        ),

    );
  }
}
