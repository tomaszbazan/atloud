import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

import '../converters/duration_to_voice.dart';
import '../l10n/supported_language.dart';

class Speaker {
  final _audioPlayer = AudioPlayer();
  final _flutterTts = FlutterTts();

  void speakText(String text) async {
    var language = await UserDataStorage.languageValue();
    await _flutterTts.setLanguage(language.code);
    await _flutterTts.speak(text);
  }
  
  void speakDuration(Duration timeLeftToEnd) async {
    var language = await UserDataStorage.languageValue();
    await _flutterTts.setLanguage(language.code);
    await _flutterTts.speak(DurationToVoice.covert(timeLeftToEnd, language));
  }

  void currentTime(BuildContext context) async {
    var now = DateTimeToString.shortConvert(DateTime.now());
    var localizations = AppLocalizations.of(context)!;
    speakText(localizations.timeAnnouncement(now));
  }

  void currentTimeWithoutContext() async {
    var now = DateTimeToString.shortConvert(DateTime.now());
    var language = await UserDataStorage.languageValue();

    switch(language) {
      case SupportedLanguage.polish:
        speakText("Jest godzina $now");
        break;
      case SupportedLanguage.english:
        speakText("It is $now o'clock");
        break;
    }
  }

  void playAlarmSound() async {
    var alarmType = await UserDataStorage.alarmTypeValue();
    var alarm = AssetSource(alarmType.filePath);
    _audioPlayer.play(alarm);
  }

  void playAlarmSoundAndVibrate() async {
    makeVibration();
    playAlarmSound();
  }

  void makeVibration() async {
    var vibrationOn = await UserDataStorage.vibrationValue();
    if (vibrationOn) {
      Vibration.vibrate(duration: 1000, repeat: 3);
    }
  }
}