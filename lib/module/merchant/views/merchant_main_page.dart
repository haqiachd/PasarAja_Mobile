import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';

class MerchantMainPage extends StatefulWidget {
  const MerchantMainPage({Key? key}) : super(key: key);

  @override
  State<MerchantMainPage> createState() => _MerchantMainPageState();
}

class _MerchantMainPageState extends State<MerchantMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merchant Main Page"),
        actions: const [],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "MERCHANT",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final confirm = await PasarAjaMessage.showConfirmation(
                  "Apakah Anda yakin ingin Logout?",
                );

                if (confirm) {
                  await PasarAjaUserService.logout();

                  Fluttertoast.showToast(msg: "Logout Berhasil");

                  Get.to(
                    const WelcomePage(),
                  );
                }
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
