class StringToDuration {
    static Duration convert(String value) {
      bool isNegative = value.startsWith('-');
      String cleanValue = value.replaceAll(RegExp(r'^-\s*'), '');
      List<String> parts = cleanValue.split(':');

      int hours = parts.length > 2 ? int.parse(parts[0]) : 0;
      int minutes = parts.length > 1 ? int.parse(parts[parts.length - 2]) : 0;
      int seconds = int.parse(parts.last);

      Duration duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
      return isNegative ? -duration : duration;
    }
}