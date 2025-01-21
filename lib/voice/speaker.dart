import 'package:atloud/shared/user_data_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Speaker {
  final _audioPlayer = AudioPlayer();
  final _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    var language = await UserDataStorage.languageValue();
    var soundOn = await UserDataStorage.soundOnValue();
    if (!soundOn) {
      return;
    }
    await _flutterTts.setLanguage(language);
    await _flutterTts.speak(text);
  }

  void playSound() async {
    var soundOn = await UserDataStorage.soundOnValue();
    if (!soundOn) {
      return;
    }
    var alarmType = await UserDataStorage.alarmTypeValue();
    var asset = switch (alarmType) {
      'FANFARY' => AssetSource('sounds/alarms/fanfares.mp3'),
      'DZWONKI' => AssetSource('sounds/alarms/bells.mp3'),
      'PIANO' => AssetSource('sounds/alarms/piano.mp3'),
      _ => AssetSource('sounds/alarms/fanfares.mp3'),
    };
    _audioPlayer.play(asset);
  }
}