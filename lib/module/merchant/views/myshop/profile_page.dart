import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';

/// Merchant Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final logout = await PasarAjaMessage.showConfirmBack(
              "Ape Logout?",
            );

            if (logout) {
              await PasarAjaUserService.logout();
              Get.offAll(const WelcomePage());
            }
          },
          child: const Text("logout"),
        ),
      ),
    );
  }
}
