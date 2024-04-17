import 'dart:io';

import 'package:d_method/d_method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasaraja_mobile/core/entities/choose_photo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:vibration/vibration.dart';

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
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ]
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
}
