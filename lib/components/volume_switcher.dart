import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

import '../shared/user_data_storage.dart';

class _VolumeSwitcherState extends State<VolumeSwitcher> {
  late int _currentVolume;
  final VolumeController _volumeController = VolumeController();
  static const IconData volumeUp = IconData(0xf028, fontFamily: 'FontAwesome');
  static const IconData volumeMute = IconData(0xf6a9, fontFamily: 'FontAwesome');

  @override
  void initState() {
    super.initState();
    // Initialize _currentVolume with a default or from a synchronous source if possible,
    // or handle its uninitialized state in build before FutureBuilder completes.
    // For now, FutureBuilder will handle the initial load.
    _volumeController.listener((volume) {
      // volume is a double from 0.0 to 1.0
      int newVolumePercent = (volume * 100).round();
      if (_currentVolume != newVolumePercent) {
        // Update the stored value to keep it in sync
        UserDataStorage.storeVolumeValue(newVolumePercent);
        if (mounted) {
          setState(() {
            _currentVolume = newVolumePercent;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _volumeController.removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: UserDataStorage.volumeValue(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            _currentVolume = snapshot.data!;
            return IconButton(
                onPressed: () {
                  int newVolume;
                  if (_currentVolume > 0) {
                    newVolume = 0;
                  } else {
                    newVolume = 50;
                  }
                  UserDataStorage.storeVolumeValue(newVolume);
                  setState(() {
                    _currentVolume = newVolume;
                  });
                },
                icon: _currentVolume > 10 ?
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
