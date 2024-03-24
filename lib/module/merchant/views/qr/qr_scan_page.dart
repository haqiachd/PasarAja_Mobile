import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    Fluttertoast.showToast(msg: 'asu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 0),
        child: AppBar(
          title: const Text('QR Scan'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: const [
            Center(
              child: Text(
                'QR Scan',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
