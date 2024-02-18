class PasarAjaUtils {
  static final RegExp regexNum = RegExp(r'[0-9]');

  static bool containsNumber(String text) {
    return regexNum.hasMatch(text);
  }
}
