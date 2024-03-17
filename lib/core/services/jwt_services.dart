// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:d_method/d_method.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main(List<String> args) async {
  String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyIwIjpbeyJpZF91c2VyIjoxLCJwaG9uZV9udW1iZXIiOiI2Mjg1NjU1ODY0NjI0IiwiZW1haWwiOiJoYWtpYWhtYWQ3NTZAZ21haWwuY29tIiwiZnVsbF9uYW1lIjoiQWNobWFkIEJhaWhhcWkiLCJwYXNzd29yZCI6IiQyeSQxMiR1U3RDbkk0ekpaYk82UWhGUXFMaG1lZUovWHR5RmxwdWdtTEMzNlIuaXpkeDFHMi5FZUt5NiIsInBpbiI6IiQyeSQxMiRuaGdNbkJyZXNoUE1pUTZ6Q1cwMlkuck5NYjJLRGNvYjBLbElkRm1hNWxwOUJMLnA3MS4wZSIsImxldmVsIjoiUGVtYmVsaSIsImlzX3ZlcmlmaWVkIjoxLCJwaG90byI6InBob3RvLXByb2ZpbGUucG5nIiwiY3JlYXRlZF9hdCI6IjIwMjQtMDMtMTZUMTU6NDM6MTYuMDAwMDAwWiIsInVwZGF0ZWRfYXQiOiIyMDI0LTAzLTE2VDE4OjAwOjE3LjAwMDAwMFoifV0sIm51bWJlciI6MSwiZXhwIjoxNzEwNjEyNDg3fQ.qn6X6ixMccodm27Io3r7fDTUP2-NcV29HMPIxefpp1qdzDWYhq2UIAvMuFDcWfm4MAAeEcF4ayH_Gd7Ph0Cb0Q';
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  print(decodedToken.entries);
  // String? deviceToken = await FirebaseMessaging.instance.getToken();
  // print(deviceToken);
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
  DMethod.log("windows info : ${windowsDeviceInfo.deviceId}");

}
