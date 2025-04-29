import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';

import '../shared/user_data_storage.dart';

class _VolumeSwitcherState extends State<VolumeSwitcher> {
  late bool _soundOn;
  static const IconData volumeUp = IconData(0xf028, fontFamily: 'FontAwesome');
  static const IconData volumeMute = IconData(0xf6a9, fontFamily: 'FontAwesome');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: UserDataStorage.soundOnValue(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            _soundOn = snapshot.data!;
            return IconButton(
                onPressed: () {
                  setState(() {
                    _soundOn = !_soundOn;
                    UserDataStorage.storeSoundOn(_soundOn);
                  });
                },
                icon: _soundOn ?
                const Icon(volumeUp, size: 70.0, color: CustomColors.textColor) :
                const Icon(volumeMute, size: 70.0, color: CustomColors.textColor)
            );
          } else if (snapshot.hasError) {
            return const Text('Error loading languages...');
          } else {
            return const Text('Loading Languages...');
          }
        });
  }
}

class VolumeSwitcher extends StatefulWidget {
  const VolumeSwitcher({super.key});

  @override
  State<VolumeSwitcher> createState() => _VolumeSwitcherState();
}
