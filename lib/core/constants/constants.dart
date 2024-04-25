class PasarAjaConstant {
  static const String appName = 'PasarAja';
  static const String rights = 'Copyright © 2024. TIF 22 Kelompok C1.';
  static const double authTolbarHeight = 40;
  static const int initLoading = 3;
  /// http://192.168.170.152:8000/api/m
  static const String baseUrl = 'http://192.168.170.152:8000/api/m';
  static const String npeString = 'Exception : NPE';
  static const String unknownError = 'unknown error';
  static const Duration transitionDuration = Duration(milliseconds: 800);
  static Future buttonDelay = Future.delayed(const Duration(seconds: 2));
  static Future onRefreshDelay = Future.delayed(
    const Duration(milliseconds: 2500),
  );
  static int onRefreshDelaySecond = 2;
}
