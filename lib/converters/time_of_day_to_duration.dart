import 'package:flutter/material.dart';

class TimeOfDayToDuration {
    static Duration convert(TimeOfDay value) {
      return Duration(hours: value.hour, minutes: value.minute);
    }
}