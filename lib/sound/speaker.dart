import 'package:atloud/shared/user_data_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

class Speaker {
  final _audioPlayer = AudioPlayer();
  final _flutterTts = FlutterTts();

  void speak(String text) async {
    var language = await UserDataStorage.languageValue();
    var soundOn = await UserDataStorage.soundOnValue();
    if (!soundOn) {
      return;
    }
    await _flutterTts.setLanguage(language);
    await _flutterTts.speak(text);
  }

  void currentTime() async {
    var now = DateFormat('HH:mm').format(DateTime.now());
    speak("Jest godzina $now");
  }

  void playSound() async {
    var soundOn = await UserDataStorage.soundOnValue();
    if (!soundOn) {
      return;
    }
    var alarmType = await UserDataStorage.alarmTypeValue();
    var alarm = AssetSource(alarmType.filePath);
    _audioPlayer.play(alarm);
  }
}