class DurationToString {
  static String twoDigits(int n) => n.toString().padLeft(2, "0");

  static String convert(Duration value) {
    String negativeSign = value.isNegative ? '- ' : '';
    String twoDigitHours = twoDigits(value.inHours.remainder(60));
    String twoDigitMinutes = twoDigits(value.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(value.inSeconds.remainder(60).abs());
    return "$negativeSign$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String shortConvert(Duration value) {
    String negativeSign = value.isNegative ? '- ' : '';
    String twoDigitHours = twoDigits(value.inHours.remainder(60).abs());
    String twoDigitMinutes = twoDigits(value.inMinutes.remainder(60).abs());
    return "$negativeSign$twoDigitHours:$twoDigitMinutes";
  }
}
