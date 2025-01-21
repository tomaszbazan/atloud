class DurationToVoice {
  static String _pluralize(int value, String singular, String plural2to4, String pluralOther) {
    if (value == 1) return singular;
    if (value % 10 >= 2 && value % 10 <= 4 && (value % 100 < 10 || value % 100 >= 20)) return plural2to4;
    return pluralOther;
  }

  static String _numbers(int value) {
    const numbersMap = {
      2: "dwie",
      22: "dwadzieścia dwie",
      32: "trzydzieści dwie",
      42: "czterdzieści dwie",
      52: "pięćdziesiąt dwie"
    };
    return numbersMap[value] ?? '$value';
  }

  static String covert(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.abs().remainder(60);

    String hoursString = hours > 0 ? '${_numbers(hours)} ${_pluralize(hours, 'godzina', 'godziny', 'godzin')}' : '';
    String minutesString = minutes > 0 ? '${_numbers(minutes)} ${_pluralize(minutes, 'minuta', 'minuty', 'minut')}' : '';

    if (duration.isNegative) {
      if (hours > 0 && minutes > 0) {
        return '$hoursString i $minutesString po czasie';
      } else if (hours > 0) {
        return '$hoursString po czasie';
      } else if (minutes > 0) {
        return '$minutesString po czasie';
      } else {
        return 'Pozostało 0 minut';
      }
    } else {
      if (hours > 0 && minutes > 0) {
        return '${_pluralize(hours, 'Pozostała', 'Pozostały', 'Pozostało')} $hoursString i $minutesString';
      } else if (hours > 0) {
        return '${_pluralize(hours, 'Pozostała', 'Pozostały', 'Pozostało')} $hoursString';
      } else if (minutes > 0) {
        return '${_pluralize(minutes, 'Pozostała', 'Pozostały', 'Pozostało')} $minutesString';
      } else {
        return 'Pozostało 0 minut';
      }
    }
  }
}
