import 'package:flutter/material.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/config/widgets/merchant_sub_appbar.dart';
import 'package:pasaraja_mobile/module/merchant/providers/qr/qr_scan_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // late QRViewController controller;
  // bool isFlashOn = false;
  // bool isFrontCamera = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: merchantSubAppbar("QR Code Scanner"),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: _buildCamera(),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildChangeCamera(),
                const SizedBox(width: 10),
                _buildFlashlight(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildCamera() {
    return Consumer<QrScanProvider>(
      builder: (context, prov, child) {
        return Stack(
          children: [
            QRView(
              key: prov.qrKey,
              onQRViewCreated: prov.onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: PasarAjaColor.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildFlashlight() {
    return Consumer<QrScanProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () {
            prov.isFlashOn = !prov.isFlashOn;
            prov.controller.toggleFlash();
          },
          heroTag: 'falshhh',
          elevation: 0,
          backgroundColor: prov.isFlashOn
              ? Colors.orangeAccent.shade200
              : Colors.redAccent.shade200,
          shape: const CircleBorder(),
          child: Icon(
            prov.isFlashOn ? Icons.flash_off : Icons.flash_on,
            color: Colors.white,
          ),
        );
      },
    );
  }

  _buildChangeCamera() {
    return Consumer<QrScanProvider>(
      builder: (context, prov, child) {
        return FloatingActionButton(
          onPressed: () {
            prov.isFrontCamera = !prov.isFrontCamera;
            prov.controller.flipCamera();
          },
          heroTag: 'frontt',
          elevation: 0,
          backgroundColor: prov.isFrontCamera
              ? Colors.purpleAccent.shade200
              : Colors.blueAccent.shade200,
          shape: const CircleBorder(),
          child: Icon(
            prov.isFrontCamera ? Icons.camera_rear : Icons.camera_front,
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    context.read<QrScanProvider>().dispose();
    super.dispose();
  }
}
