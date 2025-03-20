import 'package:intl/intl.dart';

class DateTimeToString {
  static String convert(DateTime value) {
    return DateFormat('HH:mm:ss').format(value);
  }

  static String shortConvert(DateTime value) {
    return DateFormat('HH:mm').format(value);
  }
}
