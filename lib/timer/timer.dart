import 'dart:async';

import 'package:atloud/clock/clock.dart';
import 'package:atloud/components/app_bar.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/converters/duration_to_string.dart';
import 'package:atloud/converters/duration_to_voice.dart';
import 'package:atloud/converters/time_of_day_to_duration.dart';
import 'package:atloud/components/footer.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:atloud/timer/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../sound/speaker.dart';
import '../theme/colors.dart';

class _TimerPageState extends State<TimerPage> {
  static const _refreshRate = Duration(seconds: 1);

  var _currentTime = const Duration();
  var _startingTime = const Duration();

  var _continueAfterTimer = false;
  var _period = 1;
  var _vibrationOn = true;

  Timer? _timer;
  final _speaker = Speaker();

  @override
  void initState() {
    super.initState();
    _loadDefaultValues();
  }

  Future<void> _loadDefaultValues() async {
    var currentTimerValue = await UserDataStorage.currentTimerValue();
    _continueAfterTimer = await UserDataStorage.continueAfterTimeValue();
    _vibrationOn = await UserDataStorage.vibrationValue();
    _startingTime = await UserDataStorage.startingTimerValue();
    _period = await UserDataStorage.periodValue();
    setState(() {
      _currentTime = currentTimerValue;
    });
    _startTimer();
  }

  void _showTimePicker() async {
    final TimeOfDay? time = await TimePicker.showPicker(context, _startingTime);
    setState(() {
      if(time != null) {
        _currentTime = TimeOfDayToDuration.convert(time);
        _startingTime = TimeOfDayToDuration.convert(time);
        UserDataStorage.storeCurrentTimerValue(_currentTime);
        UserDataStorage.storeStartingTimerValue(_startingTime);
        _clean();
        _startTimer();
      }
    });
  }

  void _goToClock() {
    _clean();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ClockPage()));
  }

  void _clean() {
    _timer?.cancel();
    setState(() {
      _currentTime = _startingTime;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(_refreshRate, (timer) async {
      if (_startingTime == _currentTime) {
        _speaker.speak(DurationToVoice.covert(_startingTime));
      }
      final seconds = _currentTime.inSeconds - 1;

      if (seconds >= 0 || _continueAfterTimer) {
        setState(() {
          _currentTime = Duration(seconds: seconds);
        });
        UserDataStorage.storeCurrentTimerValue(_currentTime);
      } else {
        _clean();
        return;
      }

      if (seconds == 0) {
        _speaker.playSound();
        if (_vibrationOn) {
          Vibration.vibrate(duration: 1000, repeat: 3);
        }
      } else {
        var informationNeeded = (_startingTime.inMinutes - _currentTime.inMinutes.abs()) % _period == 0;
        if (seconds % 60 == 0 && ((_continueAfterTimer && seconds < 0) || informationNeeded)) {
          _speaker.speak(DurationToVoice.covert(_currentTime));
        }
      }
    });
  }

  @override
  void dispose() {
    _clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(text: ''),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: TextButton(
                    onPressed: _showTimePicker,
                    child: Text(DurationToString.convert(_currentTime), style: TextStyle(fontSize: 70, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value)))),
            const VolumeSwitcher(),
            const Spacer(),
            FooterWidget(text: 'ZEGAR', actionOnText: _goToClock, cleanAction: () => _clean())
          ],
        ));
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}
