import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_text.dart';
import 'package:pasaraja_mobile/config/widgets/app_textfield.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/models/product_model.dart';
import 'package:pasaraja_mobile/module/merchant/models/promo_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/promo/detail_promo_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/promo/edit_promo_page.dart';
import 'package:provider/provider.dart';

class DetailPromoPage extends StatefulWidget {
  const DetailPromoPage({
    super.key,
    required this.idPromo,
  });

  final int? idPromo;

  @override
  State<DetailPromoPage> createState() => _DetailPromoPageState();
}

class _DetailPromoPageState extends State<DetailPromoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      await context.read<DetailPromoProvider>().fetchData(
            idPromo: widget.idPromo ?? 0,
          );
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: merchantSubAppbar("Detail Promo"),
      body: Consumer<DetailPromoProvider>(
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
            // create model
            PromoModel promo = provider.promo;
            // create controller
            final nameCont = TextEditingController(text: promo.productName);
            final hargaCont = TextEditingController(
              text: "Rp. ${PasarAjaUtils.formatPrice(promo.price ?? 0)}",
            );
            final promoCont = TextEditingController(
              text: "Rp. ${PasarAjaUtils.formatPrice(promo.promoPrice ?? 0)}",
            );
            final startDateCont = TextEditingController(
              text: "${promo.startDate?.toIso8601String().substring(0, 10)}",
            );
            final endDateCont = TextEditingController(
              text: "${promo.endDate?.toIso8601String().substring(0, 10)}",
            );
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    AppInputText(
                      title: "Nama Produk",
                      textField: AppTextField(
                        controller: nameCont,
                        fontSize: 21,
                        suffixIcon: const Material(),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppInputText(
                      title: "Harga Produk",
                      textField: AppTextField(
                        controller: hargaCont,
                        fontSize: 21,
                        suffixIcon: const Material(),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppInputText(
                      title: "Harga Promo",
                      textField: AppTextField(
                        controller: promoCont,
                        fontSize: 21,
                        suffixIcon: const Material(),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppInputText(
                      title: "Tanggal Awal",
                      textField: AppTextField(
                        controller: startDateCont,
                        fontSize: 21,
                        suffixIcon: const Material(),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppInputText(
                      title: "Tanggal Akhir",
                      textField: AppTextField(
                        controller: endDateCont,
                        fontSize: 21,
                        suffixIcon: const Material(),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEditPromo(context, promo),
                        const SizedBox(width: 10),
                        _buildHapusPromo(context, promo)
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SomethingWrong();
        },
      ),
    );
  }

  _buildEditPromo(BuildContext context, PromoModel promo) {
    return ActionButton(
      onPressed: () {
        Get.to(
          EditPromoPage(promo: promo),
          transition: Transition.cupertino,
        );
      },
      width: MediaQuery.of(context).size.width / 2.5,
      title: 'Edit Promo',
      state: ActionButton.stateEnabledButton,
    );
  }

  _buildHapusPromo(BuildContext context, PromoModel promo) {
    return Consumer<DetailPromoProvider>(
      builder: (context, provider, child) {
        return ActionButton(
          onPressed: () {
            provider.onDeletePressed(
              idPromo: promo.idPromo ?? 0,
              productName: promo.productName ?? '',
            );
          },
          width: MediaQuery.of(context).size.width / 2.5,
          title: 'Hapus Promo',
          state: ActionButton.stateEnabledButton,
        );
      },
    );
  }
}
