// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/config/themes/colors.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/auth/controllers/test_controller.dart';
import 'package:pasaraja_mobile/module/auth/widgets/widgets.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  bool isLoading = true;
  int state = CustomElevatedButton.stateEnabledButton;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final metu = await PasarAjaMessage.showConfirmBack(
            "Apakah Anda yakin ingin keluar, Jika ya maka password tidak akan diubah?",
          );

          if (metu == true) {
            Fluttertoast.showToast(msg: 'closed');
          }
        }
      },
      child: Scaffold(
        backgroundColor: PasarAjaColor.white,
        appBar: authAppbar(),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    PasarAjaMessage.showConfirmation(
                      "Apakah Anda yakin ingin mengirim kode OTP?",
                      actionYes: 'Kirim',
                      actionCancel: 'Batal',
                    );
                  },
                  child: const Text("Confirm Dialog"),
                ),
                ElevatedButton(
                  onPressed: () {
                    PasarAjaMessage.showInformation(
                      'Ini adalah dialog informasi',
                      actionYes: 'Login',
                    );
                  },
                  child: const Text("Information Dialog"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    PasarAjaMessage.showLoading();
                    await Future.delayed(const Duration(seconds: 3));
                    Get.back();
                  },
                  child: const Text("Loading Dialog"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    PasarAjaMessage.showSnackbarWarning(
                      'Ini adalah pesan untuk snackbar',
                    );
                  },
                  child: const Text("Snackbar Warning"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    PasarAjaMessage.showSnackbarError(
                      'Ini adalah pesan untuk snackbar',
                    );
                  },
                  child: const Text("Snackbar Error"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    PasarAjaMessage.showSnackbarInfo(
                      'Ini adalah pesan untuk snackbar',
                    );
                  },
                  child: const Text("Snackbar Info"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    PasarAjaMessage.showSnackbarSuccess(
                      'Ini adalah pesan untuk snackbar',
                    );
                  },
                  child: const Text("Snackbar Success"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
