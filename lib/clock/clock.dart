import 'dart:async';

import 'package:atloud/components/app_bar.dart';
import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:atloud/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../foreground_task/clock_task.dart';
import '../foreground_task/foreground_task_starter.dart';
import '../sound/speaker.dart';
import '../theme/colors.dart';

class _ClockPageState extends State<ClockPage> {
  final ValueNotifier<Object?> _taskDataListenable = ValueNotifier(null);

  static const _refreshRate = Duration(seconds: 1);

  var _firstInformationNeeded = true;
  DateTime _now = DateTime.now();
  DateTime _startTime = DateTime.now();

  var _period = 1;
  var _vibrationOn = true;

  Timer? _timer;
  final _speaker = Speaker();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime(_now.year, _now.month, _now.day, _now.hour, _now.minute, 0);
    _loadDefaultValues();
  }

  void _timerTick(Object data) {
    _taskDataListenable.value = data;
    print('clock $data');
  }

  Future<void> _loadDefaultValues() async {
    var screenLockValue = await UserDataStorage.screenLockValue();
    WakelockPlus.toggle(enable: screenLockValue);
    _vibrationOn = await UserDataStorage.vibrationValue();
    _period = await UserDataStorage.periodValue();
    _startTimer();
  }

  void _startTimer() {
    ForegroundTaskStarter.startService(_timerTick);

    _timer = Timer.periodic(_refreshRate, (timer) async {
      if (_firstInformationNeeded) {
        _speaker.currentTime();
        _firstInformationNeeded = false;
      }

      setState(() {
        _now = DateTime.now();
      });
      int nowInSeconds = _now.millisecondsSinceEpoch ~/ 1000;
      int startingInSeconds = _startTime.millisecondsSinceEpoch ~/ 1000;

      if (nowInSeconds % 60 == 0 && ((startingInSeconds - nowInSeconds) ~/ 60) % _period == 0) {
        _speaker.currentTime();
        if (_vibrationOn) {
          Vibration.vibrate(duration: 1000, repeat: 3);
        }
      }
    });
  }

  void _clean() {
    // ForegroundTaskStarter.stopService(); // TODO: To nie powinno tutaj być LUB nie powinieniem przekazywać tego do timera
    // FlutterForegroundTask.removeTaskDataCallback(_timerTick);
    // _taskDataListenable.dispose();

    _timer?.cancel();
  }

  void _goToTimer() {
    _clean();
    FlutterForegroundTask.sendDataToTask(ClockTaskHandler.setTimerCommand);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TimerPage(isTimerPage: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(text: ''),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: TextButton(
                    onPressed: () => _speaker.currentTime(),
                    child: Text(DateFormat('HH:mm').format(_now), style: TextStyle(fontSize: 120, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value)))
            ),
            const VolumeSwitcher(),
            const Spacer(),
            FooterWidget(text: 'MINUTNIK', actionOnText: _goToTimer, cleanAction: () => _clean())
          ],
        ),
      )
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}
