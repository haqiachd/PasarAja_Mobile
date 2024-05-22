import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:d_method/d_method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:pasaraja_mobile/core/entities/promo_entity.dart';
import 'package:pasaraja_mobile/core/utils/messages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:image/image.dart' as img;

class PasarAjaUtils {
  static final RegExp regexNum = RegExp(r'[0-9]');

  static bool containsNumber(String text) {
    return regexNum.hasMatch(text);
  }

  static Future<void> triggerVibration() async {
    bool? hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 500);
    } else {
      DMethod.log('Perangkat tidak mendukung getaran.');
    }
  }

  static showDioException(
    Dio dio, {
    bool responseData = false,
    bool requestData = false,
    bool responseHeaders = false,
    bool requestHeaders = false,
    bool responseMessage = false,
  }) {
    dio.interceptors.add(
      TalkerDioLogger(
        settings: TalkerDioLoggerSettings(
          // All http request & responses enabled for console logging
          printResponseData: responseData,
          printRequestData: requestData,
          // Request & Reposnse logs including http - headers
          printResponseHeaders: responseHeaders,
          printRequestHeaders: requestHeaders,
          // Request logs with response message
          printResponseMessage: responseMessage,
        ),
      ),
    );
  }

  static clearDioException(Dio dio) {
    dio.interceptors.clear();
  }

  static String addZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  static String formatPrice(int price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
        );
  }

  static Future<String> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.brand} ${androidInfo.model}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.productName;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      return macInfo.model;
    } else {
      return 'Unknown';
    }
  }

  static Future<ChoosePhotoEntity?>? pickPhoto(ImageSource imageSource) async {
    // request permission
    Map<Permission, PermissionStatus> status = await [
      Permission.storage,
      Permission.camera,
    ].request();

    // cek permission
    if (status[Permission.storage]!.isGranted &&
        status[Permission.camera]!.isGranted) {
      // choose photo
      final returnImage = await ImagePicker().pickImage(
        source: imageSource,
      );

      // get photo
      DMethod.log('from photo');
      if (returnImage != null) {
        return ChoosePhotoEntity(
          image: File(returnImage.path).readAsBytesSync(),
          imageSelected: File(
            returnImage.path,
          ),
        );
      } else {
        return null;
      }
    } else {
      Fluttertoast.showToast(msg: 'Permission dibutuhkan');
    }
    return null;
  }

  static Future<File?>? cropImage(
    File imgFile, {
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    // crop image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 70,
      cropStyle: cropStyle,
      aspectRatioPresets: Platform.isAndroid
          ? cropStyle == CropStyle.circle
              ? [CropAspectRatioPreset.square]
              : [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ]
          : cropStyle == CropStyle.circle
              ? [CropAspectRatioPreset.square]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9,
                ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Sesuaikan Gambar',
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          toolbarColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Sesuaikan Gambar'),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  static Future<File?> compressImage(
    File imageFile, {
    int targetSizeKB = 512,
  }) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      int fileSizeKB = imageBytes.length ~/ 1024;

      // cek apakah gambar size nya < target size kb atau tidak
      if (fileSizeKB <= targetSizeKB) {
        return imageFile;
      }

      // kalkulasi ukuran compress
      double quality = (targetSizeKB / fileSizeKB).clamp(0.1, 1.0);

      // Convert imageBytes to Uint8List
      Uint8List uint8list = Uint8List.fromList(imageBytes);

      // compress gambar
      List<int> compressedBytes = await FlutterImageCompress.compressWithList(
        uint8list,
        minHeight: 1920,
        minWidth: 1080,
        quality: (quality * 100).toInt(),
      );

      // simpan gambar hasil compress
      String newPath = imageFile.path.replaceAll('.png', '_compressed.png');
      File compressedImageFile = File(newPath);
      await compressedImageFile.writeAsBytes(compressedBytes);

      return compressedImageFile;
    } catch (e) {
      DMethod.log('Error compressing image: $e');
      return null;
    }
  }

  static bool isActivePromo(PromoEntity? promo) {
    if (promo != null) {
      // Check if promo has start and end dates
      if (promo.startDate != null && promo.endDate != null) {
        // Get the current date
        DateTime now = DateTime.now();
        // DMethod.log('PROMO PRICE : ${promo.promoPrice}');

        // Check if the current date is within the promo period
        if (now.isAfter(promo.startDate!) && now.isBefore(promo.endDate!)) {
          // Promo is active
          return true;
        }
      }
    }
    // Promo is not active or promo data is null
    return false;
  }

  static bool isSoonAndActivePromo(PromoEntity? promo) {
    if (promo != null) {
      // Check if promo has start and end dates
      if (promo.startDate != null && promo.endDate != null) {
        // Get the current date
        DateTime now = DateTime.now();
        // DMethod.log('PROMO PRICE : ${promo.promoPrice}');

        // Check if the current date is within the promo period
        if (now.isBefore(promo.endDate!)) {
          // Promo is active
          return true;
        }
      }
    }
    // Promo is not active or promo data is null
    return false;
  }

  static String formatDateString(String dateString) {
    // Parse tanggal dari string ke dalam objek DateTime
    DateTime parsedDate = DateTime.parse(dateString);

    // Format tanggal sesuai dengan format yang diinginkan (dd MMMM yyyy)
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);

    return formattedDate;
  }

  static List<T> shuffleList<T>(List<T> inputList) {
    List<T> resultList = List.from(inputList);
    Random random = Random();

    for (int i = resultList.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      T temp = resultList[i];
      resultList[i] = resultList[j];
      resultList[j] = temp;
    }

    return resultList;
  }

  static Future<void> launchURL(final String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      PasarAjaMessage.showSnackbarError('Gagal Membuka Link Update');
    }
  }
}
