import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/themes/lotties.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:pasaraja_mobile/config/widgets/action_button.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_error.dart';
import 'package:pasaraja_mobile/config/widgets/image_network_placeholder.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/merchant/controllers/order_controller.dart';
import 'package:pasaraja_mobile/module/merchant/models/transaction_model.dart';
import 'package:pasaraja_mobile/module/merchant/providers/order/order_intaking_provider.dart';
import 'package:pasaraja_mobile/module/merchant/views/order/order_detail_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanProvider extends ChangeNotifier {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  final _trxController = OrderController();

  String _oldOrderCode = '';

  // state of flashlight
  bool _isFlashOn = false;
  bool get isFlashOn => _isFlashOn;
  set isFlashOn(bool i) {
    _isFlashOn = i;
    notifyListeners();
  }

  // state for camera type
  bool _isFrontCamera = false;
  bool get isFrontCamera => _isFrontCamera;
  set isFrontCamera(bool i) {
    _isFrontCamera = i;
    notifyListeners();
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) async {
        // handle agar qr yang tidak valid tidak bisa discan berulang-ulang
        if(_oldOrderCode == scanData.code){
          return;
        }else{
          _oldOrderCode = scanData.code ?? '';
        }
        DMethod.log("Scanned Data : ${scanData.code}");
        DMethod.log("Code : ${scanData.code?.substring(0, 8)}");
        if (scanData.code?.substring(0, 8) == 'PasarAja') {
          // pause camera
          controller.pauseCamera();

          PasarAjaMessage.showLoading(loadingColor: Colors.white);

          // get id shop
          final idShop = await PasarAjaUserService.getShopId();

          // get trx data
          final scanTrx = await _trxController.scanTrx(
            idShop: idShop,
            orderCode: scanData.code ?? '',
          );
          Get.back();

          if (scanTrx is DataSuccess) {
            _oldOrderCode = '';
            TransactionModel trxData = scanTrx.data as TransactionModel;
            // menampilkan bottom sheet
            _showBottomSheet(trxData, controller);
          }

          if (scanTrx is DataFailed) {
            await PasarAjaMessage.showWarning(
              scanTrx.error?.error.toString() ?? PasarAjaConstant.unknownError,
            );
            controller.resumeCamera();
          }
        }
      },
    );
  }

  void _showBottomSheet(TransactionModel order, QRViewController controller) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaksi Ditemukan',
                    style: PasarAjaTypography.sfpdBold.copyWith(
                      fontSize: 23,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                      controller.resumeCamera();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                order.orderId ?? 'null',
                style: PasarAjaTypography.sfpdSemibold.copyWith(
                  fontSize: 20,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${order.details?.length ?? 0} x product",
                style: PasarAjaTypography.sfpdSemibold.copyWith(fontSize: 18),
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: order.details!
                    .map(
                      (prod) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${prod.quantity} x ${prod.productName}",
                            style: PasarAjaTypography.sfpdRegular.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Rp. ${PasarAjaUtils.formatPrice(prod.subTotal ?? 0)}",
                            style: PasarAjaTypography.sfpdRegular.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Text(
                "${order.totalQuantity} Produk",
                style: PasarAjaTypography.sfpdBold.copyWith(
                  fontSize: 20,
                ),
              ),
              Text(
                "Rp. ${PasarAjaUtils.formatPrice(order.totalPrice ?? 0)}",
                style: PasarAjaTypography.sfpdBold.copyWith(
                  fontSize: 20,
                ),
              ),
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        placeholder: (context, url) {
                          return const ImageNetworkPlaceholder();
                        },
                        errorWidget: (context, url, error) {
                          return const ImageErrorNetwork();
                        },
                        imageUrl: order.userData?.photo ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        order.userData?.fullName ?? '',
                        style: PasarAjaTypography.sfpdBold.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        order.userData?.email ?? '',
                        style: PasarAjaTypography.sfpdBold.copyWith(
                          fontSize: 15,
                          color: PasarAjaColor.gray4,
                        ),
                      ),
                      Text(
                        order.userData?.phoneNumber ?? '',
                        style: PasarAjaTypography.sfpdBold.copyWith(
                          fontSize: 15,
                          color: PasarAjaColor.gray4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildButtonSubmitted(order),
                  const SizedBox(width: 10),
                  _buildButtonDetail(order),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      isDismissible: false,
    ).then(
      (value) {
        controller.resumeCamera();
      },
    );
  }

  Expanded _buildButtonSubmitted(TransactionModel order) {
    return Expanded(
      child: ActionButton(
        onPressed: () async {
          // show loading
          PasarAjaMessage.showLoading(loadingColor: Colors.white);

          // get id shop
          final idShop = await PasarAjaUserService.getShopId();

          final dataState = await _trxController.submittedTrx(
            idShop: idShop,
            orderCode: order.orderCode ?? '',
          );

          // close loading
          Get.back();
          Get.back();

          if (dataState is DataSuccess) {
            // show success bottom sheet
            _showSuccessBottomSheet();
          }

          if (dataState is DataFailed) {
            PasarAjaUtils.triggerVibration();
            await PasarAjaMessage.showSnackbarWarning(
              dataState.error?.error.toString() ??
                  PasarAjaConstant.unknownError,
            );
          }
        },
        title: 'Serahkan Pesanan',
        state: ActionButton.stateEnabledButton,
      ),
    );
  }

  Expanded _buildButtonDetail(TransactionModel order) {
    return Expanded(
      child: ActionButton(
        onPressed: () {
          Get.back();
          // membuka window detail transaksi
          Get.off(
            OrderDetailPage(
              orderCode: order.orderCode ?? '',
              provider: OrderInTakingProvider(),
            ),
            transition: Transition.downToUp,
          );
        },
        title: 'Lihat Detail',
        state: ActionButton.stateEnabledButton,
      ),
    );
  }

  void _showSuccessBottomSheet() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width / 1.1,
                height: Get.width / 1.1,
                child: Lottie.asset(PasarAjaLottie.orderSuccess),
              ),
              Text(
                'Pesanan telah berhasil diserahkan.',
                textAlign: TextAlign.center,
                style: PasarAjaTypography.sfpdSemibold.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ).then(
      (value) {
        controller.resumeCamera();
      },
    );
  }
}
