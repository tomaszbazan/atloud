import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

import '../shared/user_data_storage.dart';

class _VolumeSwitcherState extends State<VolumeSwitcher> {
  int _currentVolume = 0;
  final VolumeController _volumeController = VolumeController();
  static const IconData volumeUp = IconData(0xf028, fontFamily: 'FontAwesome');
  static const IconData volumeMute = IconData(0xf6a9, fontFamily: 'FontAwesome');
  final _minimumVolume = 10;
  final iconSize = 50.0;

  @override
  void initState() {
    super.initState();
    _volumeController.listener((volume) {
      if (!mounted) return;
      int newVolumePercent = (volume * 100).round();
      if (_currentVolume != newVolumePercent) {
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return IconButton(
            icon: pickIconBasedOnMinimumVolume(),
            onPressed: null,
          );
        } else if (snapshot.hasError) {
          return IconButton(
            icon: Icon(Icons.error_outline, size: iconSize),
            onPressed: null,
          );
        } else if (snapshot.hasData) {
          if (_currentVolume != snapshot.data!) {
            _currentVolume = snapshot.data!;
          }
          return IconButton(
            onPressed: () {
              int newVolume;
              if (_currentVolume > 0) {
                newVolume = 0;
              } else {
                newVolume = 50;
              }
              setState(() {
                _currentVolume = newVolume;
              });
              UserDataStorage.storeVolumeValue(newVolume);
            },
            icon: pickIconBasedOnMinimumVolume(),
          );
        } else {
          return IconButton(
            icon: Icon(Icons.help_outline, size: iconSize),
            onPressed: null,
          );
        }
      },
    );
  }

  Icon pickIconBasedOnMinimumVolume() {
    return _currentVolume > _minimumVolume ? Icon(volumeUp, size: iconSize) : Icon(volumeMute, size: iconSize);
  }
}

class VolumeSwitcher extends StatefulWidget {
  const VolumeSwitcher({super.key});

  @override
  State<VolumeSwitcher> createState() => _VolumeSwitcherState();
}
