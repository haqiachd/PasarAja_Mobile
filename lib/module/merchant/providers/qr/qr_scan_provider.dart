import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/typography.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanProvider extends ChangeNotifier {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

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
    controller.scannedDataStream.listen((scanData) {
      DMethod.log("Scanned Data : ${scanData.code}");
      // puse camera
      controller.pauseCamera();

      // menampilkan bottom sheet
      _showBottomSheet(scanData.code ?? 'NULL', controller);
    });
  }

  void _showBottomSheet(String qrData, QRViewController controller) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'QR Code Data',
                  style: PasarAjaTypography.sfpdBold.copyWith(
                    fontSize: 20,
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
              qrData,
              style: PasarAjaTypography.sfpdSemibold.copyWith(
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      isDismissible: false,
    );
  }
}
