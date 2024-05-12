import 'dart:io';
import 'package:pasaraja_mobile/config/themes/Typography.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:d_method/d_method.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:get/get.dart';
import 'package:pasaraja_mobile/core/constants/constants.dart';
import 'package:pasaraja_mobile/core/services/user_services.dart';
import 'package:pasaraja_mobile/core/sources/data_state.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:pasaraja_mobile/core/utils/utils.dart';
import 'package:pasaraja_mobile/module/auth/views/welcome_page.dart';
import 'package:pasaraja_mobile/module/customer/views/customer_main_page.dart';
import 'package:pasaraja_mobile/module/merchant/views/merchant_main_page.dart';
import 'package:pasaraja_mobile/redirect_page.dart';

class ServerStatusModel {
  final String? isUpdate;
  final String? updateLink;
  final String? updateDesc;
  final String? isActive;

  const ServerStatusModel({
    this.isUpdate,
    this.updateLink,
    this.updateDesc,
    this.isActive,
  });

  factory ServerStatusModel.fromJson(Map<String, dynamic> json) {
    return ServerStatusModel(
      isUpdate: json['is_update'] ?? '',
      isActive: json['is_active'] ?? '',
      updateLink: json['update_link'] ?? '',
      updateDesc: json['update_desc'] ?? '',
    );
  }
}

class SplashScreenController {
  final Dio _dio = Dio();

  Future<DataState<ServerStatusModel>> fetchServerStatus() async {
    try {
      final response = await _dio.get(
        // 'https://arenafinder.tifnganjuk.com/controllers/pasaraja/status.php',
        '${PasarAjaConstant.baseUrl}/sts',
        options: Options(
          validateStatus: (status) {
            return status == HttpStatus.ok;
          },
        ),
      );

      final Map<String, dynamic> payload = response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DataSuccess(ServerStatusModel.fromJson(payload['data']));
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: payload['message'],
          ),
        );
      }
    } on DioException catch (ex) {
      return DataFailed(ex);
    }
  }
}

class SplashScreenProvider extends ChangeNotifier {
  final _controller = SplashScreenController();

  bool _visibleLoading = true;

  bool get visibleLoading => _visibleLoading;

  Future<void> prepareApp(BuildContext context) async {
    // await showNotesDialog(context);
    try {
      final dataState = await _controller.fetchServerStatus();

      if (dataState is DataSuccess) {
        final status = dataState.data as ServerStatusModel;

        switch (status.isActive) {
          case "active":
            {
              // cek update
              switch (status.isUpdate) {
                case "update":
                  {
                    _visibleLoading = false;
                    notifyListeners();
                    final confirm = await PasarAjaMessage.showConfirmation(
                      'Update aplikasi telah tersedia. Apakah Anda ingin mengupdate sekarang?\n\nApa yang baru? \n${status.updateDesc}',
                      actionCancel: 'Nanti Saja',
                      actionYes: 'Update',
                    );

                    _visibleLoading = true;
                    notifyListeners();

                    if (!confirm) {
                      await _checkLoginStatus();
                      return;
                    }

                    // open url
                    await PasarAjaUtils.launchURL(status.updateLink ?? '');
                    exit(0);
                  }
                case "force_update":
                  {
                    _visibleLoading = false;
                    notifyListeners();
                    await PasarAjaMessage.showInformation(
                      'Versi aplikasi Anda sudah kedaluwarsa, harap perbarui aplikasi Anda.\n\nApa yang baru? \n${status.updateDesc}',
                      actionYes: 'Update',
                    );

                    // open url
                    await PasarAjaUtils.launchURL(status.updateLink ?? '');
                    exit(0);
                  }
                default:
                  {
                    await _checkLoginStatus();
                    break;
                  }
              }
              break;
            }
          case "inactive":
            {
              // ke halaman redirect
              Get.offAll(
                const RedirectPage(
                  status: 'inactive',
                ),
                transition: Transition.rightToLeft,
              );
              break;
            }
          case "maintenance":
            {
              // ke halaman redirect
              Get.offAll(
                const RedirectPage(
                  status: 'maintenance',
                ),
                transition: Transition.rightToLeft,
              );
              break;
            }
          default:
            {
              // ke halaman redirect
              Get.offAll(
                const RedirectPage(
                  status: 'unknown',
                ),
                transition: Transition.rightToLeft,
              );
            }
        }
      }

      if (dataState is DataFailed) {
        PasarAjaMessage.showSnackbarError(
          dataState.error?.error.toString() ?? PasarAjaConstant.unknownError,
        );
      }
    } catch (ex) {
      PasarAjaMessage.showSnackbarError(ex.toString());
    }
  }

  Future<void> _checkLoginStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      // mendapatkan data login
      bool isLoggedIn = await PasarAjaUserService.isLoggedIn();

      // get device info
      String? deviceName = await PasarAjaUtils.getDeviceModel();
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      DMethod.log('DEVICE NAME : $deviceName');
      DMethod.log('DEVICE TOKEN : $deviceToken');

      // Get.to(const MyTestPage(), transition: Transition.downToUp);
      // return;

      // jika user sudah login
      if (isLoggedIn) {
        // mendapatkan user data
        String email = await PasarAjaUserService.getUserData(
          PasarAjaUserService.email,
        );
        String level = await PasarAjaUserService.getUserData(
          PasarAjaUserService.level,
        );
        level = level.toLowerCase();
        DMethod.log("Login as : $email");
        DMethod.log("user level : $level");
        DMethod.log(
          "expired on : ${await FlutterSessionJwt.getExpirationDateTime()}",
        );

        // cek sesi masih aktif atau tidak
        if (await FlutterSessionJwt.isTokenExpired()) {
          await PasarAjaMessage.showInformation(
            "Sesi Anda Telah Berakhir. Silakan Login Kembali.",
            actionYes: "Login",
            barrierDismissible: false,
          );

          // buka halaman welcome
          Get.offAll(
            const WelcomePage(),
            transition: Transition.downToUp,
            duration: PasarAjaConstant.transitionDuration,
          );

          return;
        }

        // jika user login sebagai penjual
        if (level == UserLevel.penjual.name) {
          // membuka halaman utama
          Get.offAll(
            const MerchantMainPage(),
            transition: Transition.downToUp,
            duration: PasarAjaConstant.transitionDuration,
          );
        }
        // jika user login sebagai pembeli
        else if (level == UserLevel.pembeli.name) {
          // membuka halaman utama
          Get.offAll(
            const CustomerMainPage(),
            transition: Transition.downToUp,
            duration: PasarAjaConstant.transitionDuration,
          );
        } else {
          Get.snackbar("ERROR", "Your account level is unknown");
        }
      } else {
        DMethod.log("BELUM LOGIN");
        Get.offAll(
          const WelcomePage(),
          transition: Transition.downToUp,
          duration: PasarAjaConstant.transitionDuration,
        );
      }
    } catch (ex) {
      Get.offAll(
        const WelcomePage(),
        transition: Transition.downToUp,
        duration: PasarAjaConstant.transitionDuration,
      );
    }
  }
}
