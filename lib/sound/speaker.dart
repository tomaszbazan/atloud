import 'package:atloud/converters/date_time_to_string.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';

class Speaker {
  final _audioPlayer = AudioPlayer();
  final _flutterTts = FlutterTts();

  void speak(String text) async {
    var language = await UserDataStorage.languageValue();
    await _flutterTts.setLanguage(language);
    await _flutterTts.speak(text);
  }

  void currentTime() async {
    var now = DateTimeToString.shortConvert(DateTime.now());
    speak("Jest godzina $now");
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