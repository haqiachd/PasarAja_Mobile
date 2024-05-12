import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/app_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/loading_indicator.dart';
import 'package:pasaraja_mobile/config/widgets/page_error_message.dart';
import 'package:pasaraja_mobile/config/widgets/something_wrong.dart';
import 'package:pasaraja_mobile/core/sources/provider_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_input_text.dart';
import 'package:pasaraja_mobile/module/auth/widgets/filled_button.dart';
import 'package:pasaraja_mobile/module/auth/widgets/textfield.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:pasaraja_mobile/module/customer/provider/order/order_complain_provider.dart';
import 'package:provider/provider.dart';

class OrderComplainPage extends StatefulWidget {
  const OrderComplainPage({
    Key? key,
    required this.prod,
    required this.isEdit,
    this.idTrx,
    this.orderCode,
  }) : super(key: key);

  final TransactionDetailHistoryModel prod;
  final bool isEdit;
  final int? idTrx;
  final String? orderCode;

  @override
  State<OrderComplainPage> createState() => _OrderComplainPageState();
}

class _OrderComplainPageState extends State<OrderComplainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        try {
          await context.read<OrderComplainProvider>().onInit(
                prod: widget.prod,
                isEdit: widget.isEdit,
                orderCode: widget.orderCode,
                idTrx: widget.idTrx,
              );
        } catch (ex) {
          Fluttertoast.showToast(msg: ex.toString());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final metu = await PasarAjaMessage.showConfirmBack(
            'Apakah Anda yakin ingin membatalkan komplain produk?',
          );

          if (metu) {
            Get.back();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customerSubAppbar('Komplain Produk'),
        body: Consumer<OrderComplainProvider>(
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
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AuthInputText(
                        title: 'Keterangan Produk',
                        textField: AuthTextField(
                          fontSize: 20,
                          controller: provider.namaCont,
                          readOnly: true,
                          suffixIcon: const Material(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppInputTextArea(
                        title: 'Masukan Alasasn Komplain',
                        textArea: AppTextArea(
                          controller: provider.reasonCont,
                          fontSize: 15,
                          maxLength: 150,
                          onChanged: (str) {
                            provider.validateReason();
                          },
                          suffixIcon: const Material(),
                          showCounter: true,
                          hintText: 'Lorem ipsum dolor sit amet',
                        ),
                      ),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.center,
                        child: AuthFilledButton(
                          onPressed: () async {
                            await provider.onSaveButtonPressed();
                          },
                          title: 'Simpan',
                          state: provider.buttonState,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return const SomethingWrong();
          },
        ),
      ),
    );
  }
}
