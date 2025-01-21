import 'package:flutter/material.dart';

class DurationToTimeOfDay {
  static TimeOfDay convert(Duration value) {
    return TimeOfDay(hour: value.inHours.remainder(60), minute: value.inMinutes.remainder(60));
  }
}
