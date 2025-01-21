import 'package:flutter/material.dart';

import '../converters/duration_to_time_of_day.dart';
import '../theme/theme.dart';

class TimePicker {
  static Future<TimeOfDay?> showPicker(BuildContext context, Duration startingTime) async {
    return await showTimePicker(
        context: context,
        initialTime: DurationToTimeOfDay.convert(startingTime),
        cancelText: 'ANULUJ',
        confirmText: 'OK',
        initialEntryMode: TimePickerEntryMode.dialOnly,
        orientation: Orientation.portrait,
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: CustomTheme.lightTheme,
              child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                      child: child!
                  )
              )
          );
        });
  }
}
