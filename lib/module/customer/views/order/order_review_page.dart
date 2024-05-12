import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_textarea.dart';
import 'package:pasaraja_mobile/config/widgets/app_input_title.dart';
import 'package:pasaraja_mobile/config/widgets/app_textarea.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_input_text.dart';
import 'package:pasaraja_mobile/module/auth/widgets/auth_title.dart';
import 'package:pasaraja_mobile/module/auth/widgets/filled_button.dart';
import 'package:pasaraja_mobile/module/auth/widgets/textfield.dart';
import 'package:pasaraja_mobile/module/customer/models/transaction_detail_history_model.dart';
import 'package:pasaraja_mobile/module/customer/provider/order/order_review_provider.dart';
import 'package:pasaraja_mobile/module/customer/widgets/customer_sub_appbar.dart';
import 'package:provider/provider.dart';

class OrderReviewPage extends StatefulWidget {
  const OrderReviewPage({
    Key? key,
    required this.prod,
    required this.isEdit,
    required this.star,
    this.idTrx,
    this.orderCode,
  }) : super(key: key);

  final TransactionDetailHistoryModel prod;
  final int star;
  final bool isEdit;
  final int? idTrx;
  final String? orderCode;

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) async {
        try {
          await context.read<OrderReviewProvider>().onInit(
            prod: widget.prod,
            isEdit: widget.isEdit,
            star: widget.star,
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
            'Apakah Anda yakin ingin membatalkan ulasan produk?',
          );

          if (metu) {
            Get.back();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customerSubAppbar('Ulasan Produk'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
            child: Column(
              children: [
                _buildNameProduct(),
                const SizedBox(height: 30),
                _buildStarReview(),
                const SizedBox(height: 30),
                _buildCommentProduct(),
                const SizedBox(height: 50),
                _buildButtonSave(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNameProduct() {
    return Consumer<OrderReviewProvider>(
      builder: (context, provider, child) {
        return AuthInputText(
          title: 'Keterangan Produk',
          textField: AuthTextField(
            fontSize: 20,
            controller: provider.namaCont,
            readOnly: true,
            suffixIcon: const Material(),
          ),
        );
      },
    );
  }

  _buildStarReview() {
    return Consumer<OrderReviewProvider>(
      builder: (context, provider, child) {
        List<Widget> starIcons = [];
        for (int i = 0; i < 5; i++) {
          if (i < provider.numberOfStar) {
            starIcons.add(
              InkWell(
                onTap: () {
                  provider.numberOfStar = ++i;
                },
                child: Icon(
                  Icons.star,
                  size: Get.width / 10,
                  color: Colors.orange,
                ),
              ),
            );
          } else {
            starIcons.add(
              InkWell(
                onTap: () {
                  provider.numberOfStar = ++i;
                },
                child: Icon(
                  Icons.star_border,
                  size: Get.width / 10,
                  color: Colors.orange,
                ),
              ),
            );
          }
        }

        // return star
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppInputTitle(title: 'Beri Ulasan dari 1-5'),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: starIcons,
            ),
          ],
        );
      },
    );
  }

  _buildCommentProduct() {
    return Consumer<OrderReviewProvider>(
      builder: (context, provider, child) {
        return AppInputTextArea(
          title: 'Masukan Alasasn Komplain',
          textArea: AppTextArea(
            controller: provider.commentCont,
            fontSize: 15,
            maxLength: 150,
            onChanged: (str) {
              provider.validateReason();
            },
            suffixIcon: const Material(),
            showCounter: true,
            hintText: 'Lorem ipsum dolor sit amet',
          ),
        );
      },
    );
  }

  _buildButtonSave() {
    return Consumer<OrderReviewProvider>(
      builder: (context, provider, child) {
        return Align(
          alignment: Alignment.center,
          child: AuthFilledButton(
            onPressed: () async {
              await provider.onSaveButtonPressed();
            },
            title: 'Simpan',
            state: provider.buttonState,
          ),
        );
      },
    );
  }
}
