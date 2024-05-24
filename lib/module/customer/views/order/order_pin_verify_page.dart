import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:pasaraja_mobile/config/themes/images.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_init.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_input_pin.dart';
import 'package:pasaraja_mobile/module/auth/widgets/pin_view.dart';
import 'package:pasaraja_mobile/module/customer/models/cart_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/order/order_pin_verify_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:provider/provider.dart';

class OrderPinVerifyPage extends StatefulWidget {
  const OrderPinVerifyPage({
    super.key,
    required this.from,
    required this.selectedDate,
    required this.cartModel,
  });

  final int from;
  final String selectedDate;
  final CartModel cartModel;

  @override
  State<OrderPinVerifyPage> createState() => _OrderPinVerifyPageState();
}

class _OrderPinVerifyPageState extends State<OrderPinVerifyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<CustomerOrderPinVerifyProvider>().onInit(
            from: widget.from,
            selectedDate: widget.selectedDate,
            cartModel: widget.cartModel,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final metu = await PasarAjaMessage.showConfirmBack(
            "Apakah Anda yakin ingin keluar dari verifikasi PIN?",
          );

          if (metu) {
            Get.back();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customerSubAppbar('Verifikasi PIN PasarAja'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 19,
              right: 19,
              top: 70,
            ),
            child: Column(
              children: [
                const AuthInit(
                  image: PasarAjaImage.ilVerifyOtp,
                  title: 'Masukan PIN PasarAja',
                  description:
                      'Silakan masukkan PIN PasarAja Anda untuk mengonfirmasi identitas Anda.',
                ),
                const SizedBox(height: 19),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildInputOtp(),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () async {
                    await PasarAjaMessage.showInformation(
                      "Silakan logout, lalu temukan menu 'Ubah PIN' untuk mengubah PIN Anda",
                      actionYes: "OK",
                    );
                  },
                  child: Text(
                    'Lupa PIN',
                    style: PasarAjaTypography.bold14.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildInputOtp() {
    return Consumer<CustomerOrderPinVerifyProvider>(
      builder: (context, provider, child) {
        return AuthInputPin(
          title: 'Masukan OTP',
          authPin: AuthPin(
            length: 6,
            onCompleted: (value) async {
              DMethod.log('validate pin');
              provider.onValidatePin(
                pin: value,
              );
            },
          ),
        );
      },
    );
  }
}
