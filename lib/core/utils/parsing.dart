class PasarAjaParsing {

  static int tryInt(
    dynamic data, {
    int defaultValue = 0,
  }) {
    return int.tryParse('$data') ?? defaultValue;
  }

  static double tryDouble(
      dynamic data, {
        double defaultValue = 0,
      }) {
    return double.tryParse('$data') ?? defaultValue;
  }

}
