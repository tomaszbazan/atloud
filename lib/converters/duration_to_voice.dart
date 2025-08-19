import 'package:atloud/l10n/supported_language.dart';

class DurationToVoice {
  static String covert(Duration duration, SupportedLanguage language) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.abs().remainder(60);

    switch(language) {
      case SupportedLanguage.polish:
        return _convertPolish(duration, hours, minutes);
      case SupportedLanguage.english:
        return _convertEnglish(duration, hours, minutes);
    }
  }

  static String _pluralizePolish(int value, String singular, String plural2to4, String pluralOther) {
    if (value == 1) return singular;
    if (value % 10 >= 2 && value % 10 <= 4 && (value % 100 < 10 || value % 100 >= 20)) return plural2to4;
    return pluralOther;
  }

  static String _pluralizeEnglish(int value, String singular, String plural) {
    return value == 1 ? singular : plural;
  }

  static String _numbersPolish(int value) {
    const numbersMap = {
      2: "dwie",
      22: "dwadzieścia dwie",
      32: "trzydzieści dwie",
      42: "czterdzieści dwie",
      52: "pięćdziesiąt dwie"
    };
    return numbersMap[value] ?? '$value';
  }

  static String _numbersEnglish(int value) {
    return '$value';
  }

  static String _convertPolish(Duration duration, int hours, int minutes) {
    String hoursString = hours > 0 ? '${_numbersPolish(hours)} ${_pluralizePolish(hours, 'godzina', 'godziny', 'godzin')}' : '';
    String minutesString = minutes > 0 ? '${_numbersPolish(minutes)} ${_pluralizePolish(minutes, 'minuta', 'minuty', 'minut')}' : '';

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
        return '${_pluralizePolish(hours, 'Pozostała', 'Pozostały', 'Pozostało')} $hoursString i $minutesString';
      } else if (hours > 0) {
        return '${_pluralizePolish(hours, 'Pozostała', 'Pozostały', 'Pozostało')} $hoursString';
      } else if (minutes > 0) {
        return '${_pluralizePolish(minutes, 'Pozostała', 'Pozostały', 'Pozostało')} $minutesString';
      } else {
        return 'Pozostało 0 minut';
      }
    }
  }

  static String _convertEnglish(Duration duration, int hours, int minutes) {
    String hoursString = hours > 0 ? '${_numbersEnglish(hours)} ${_pluralizeEnglish(hours, 'hour', 'hours')}' : '';
    String minutesString = minutes > 0 ? '${_numbersEnglish(minutes)} ${_pluralizeEnglish(minutes, 'minute', 'minutes')}' : '';

    if (duration.isNegative) {
      if (hours > 0 && minutes > 0) {
        return '$hoursString and $minutesString overdue';
      } else if (hours > 0) {
        return '$hoursString overdue';
      } else if (minutes > 0) {
        return '$minutesString overdue';
      } else {
        return '0 minutes remaining';
      }
    } else {
      if (hours > 0 && minutes > 0) {
        return '$hoursString and $minutesString remaining';
      } else if (hours > 0) {
        return '$hoursString remaining';
      } else if (minutes > 0) {
        return '$minutesString remaining';
      } else {
        return '0 minutes remaining';
      }
    }
  }
}
