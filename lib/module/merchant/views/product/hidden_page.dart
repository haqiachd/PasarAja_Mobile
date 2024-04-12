import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/product/hidden_provider.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/item_hidden.dart';
import 'package:pasaraja_mobile/module/merchant/widgets/switcher_setting.dart';
import 'package:provider/provider.dart';

class HiddenPage extends StatefulWidget {
  const HiddenPage({super.key});

  @override
  State<HiddenPage> createState() => HiddenPageState();
}

class HiddenPageState extends State<HiddenPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      await Provider.of<HiddenProvider>(
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
      appBar: merchantSubAppbar('Produk Disembunyikan'),
      body: RefreshIndicator(
        onRefresh: () async {
          await PasarAjaConstant.onRefreshDelay;
          _fetchData();
        },
        // MENDAPATKAN DATA
        child: Consumer<HiddenProvider>(
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
                itemCount: value.hiddens.length,
                itemBuilder: (context, index) {
                  final ProductModel data = value.hiddens[index];
                  return ItemHidden(
                    product: data,
                    onTap: () {
                      _showBottomSheet(
                        context,
                        data.id ?? 0,
                      );
                    },
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

  _showBottomSheet(BuildContext context, int idProduct) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Visibilitas',
                style: PasarAjaTypography.sfpdBold.copyWith(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20.0),
              Consumer<HiddenProvider>(
                builder: (context, prov, child) {
                  return SwitcherSetting(
                    title: 'Tampilkan Produk',
                    description: 'Tampilkan produk dihalaman beranda pembeli',
                    value: prov.isShown,
                    onChanged: (value) {
                      context.read<HiddenProvider>().isShown = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 40.0),
              ActionButton(
                title: 'Simpan',
                state: ActionButton.stateEnabledButton,
                onPressed: () async {
                  await context.read<HiddenProvider>().updateVisibility(
                        idProduct: idProduct,
                      );
                  await _fetchData();
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
