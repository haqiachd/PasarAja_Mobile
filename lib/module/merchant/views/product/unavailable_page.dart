import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/unavailable_provider.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_unavailable.dart';
import 'package:provider/provider.dart';

class UnavailablePage extends StatefulWidget {
  const UnavailablePage({super.key});

  @override
  State<UnavailablePage> createState() => UnavailablePageState();
}

class UnavailablePageState extends State<UnavailablePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      await Provider.of<UnavailableProvider>(
        context,
        listen: false,
      ).fetchData();
    } catch (ex) {
      Fluttertoast.showToast(msg: PasarAjaConstant.unknownError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar('Stok Habis'),
      body: RefreshIndicator(
        onRefresh: () async {
          await PasarAjaConstant.onRefreshDelay;
          _fetchData();
        },
        // MENAMPILKAN DATA
        child: Consumer<UnavailableProvider>(
          builder: (context, value, child) {
            // menampilkan loading
            if (value.state is OnLoadingState) {
              return const LoadingIndicator();
            }

            // jika error
            if (value.state is OnFailureState) {
              return PageErrorMessage(
                onFailureState: value.state as OnFailureState,
              );
            }

            // berhasil
            if (value.state is OnSuccessState) {
              return ListView.builder(
                itemCount: value.unavailables.length,
                itemBuilder: (context, index) {
                  return ItemUnavailable(
                    product: value.unavailables[index],
                  );
                },
              );
            }

            return const SomethingWrong();
          },
        ),
      ),
    );
  }
}
