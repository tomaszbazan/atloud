import 'package:atloud/components/app_bar.dart';
import 'package:atloud/components/footer.dart';
import 'package:atloud/components/volume_switcher.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:atloud/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../voice/speaker.dart';
import '../theme/colors.dart';

class _ClockPageState extends State<ClockPage> {
  final _speaker = Speaker();

  @override
  void initState() {
    super.initState();
    _loadDefaultValues();
  }

  Future<void> _loadDefaultValues() async {
    var screenLockValue = await UserDataStorage.screenLockValue();
    WakelockPlus.toggle(enable: screenLockValue);
  }

  void _goToTimer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TimerPage()));
  }

  @override
  Widget build(BuildContext context) {
    var now = DateFormat('HH:mm').format(DateTime.now());
    _speaker.speak("Jest godzina $now");
    return Scaffold(
      appBar: const AppBarWidget(text: 'ZEGAR ATLOUD'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: TextButton(
                    onPressed: () => _speaker.speak("Jest godzina $now"),
                    child: Text(now, style: TextStyle(fontSize: 120, color: CustomColors.textColor, fontFamily: CustomFonts.abril.value)))
            ),
            const VolumeSwitcher(),
            const Spacer(),
            FooterWidget(text: 'MINUTNIK', actionOnText: _goToTimer)
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
