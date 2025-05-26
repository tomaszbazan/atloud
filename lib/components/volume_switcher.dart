import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

import '../shared/user_data_storage.dart';

class _VolumeSwitcherState extends State<VolumeSwitcher> {
  int _currentVolume = 0;
  final VolumeController _volumeController = VolumeController();
  static const IconData volumeUp = IconData(0xf028, fontFamily: 'FontAwesome');
  static const IconData volumeMute = IconData(0xf6a9, fontFamily: 'FontAwesome');

  @override
  void initState() {
    super.initState();
    // Listener for system volume changes
    _volumeController.listener((volume) {
      if (!mounted) return; // Ensure widget is still in the tree
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator or a disabled icon based on the current _currentVolume (initially 0)
          return IconButton(
            icon: _currentVolume > 10
                ? Icon(volumeUp, size: 70.0, color: CustomColors.textColor.withOpacity(0.5))
                : Icon(volumeMute, size: 70.0, color: CustomColors.textColor.withOpacity(0.5)),
            onPressed: null, // Disabled while loading
          );
        } else if (snapshot.hasError) {
          // Optionally log snapshot.error for more details
          return IconButton(
            icon: Icon(Icons.error_outline, size: 70.0, color: Colors.red.withOpacity(0.5)),
            onPressed: null, // Disabled on error
          );
        } else if (snapshot.hasData) {
          // Data loaded successfully, update _currentVolume if it's from the initial load
          // or if the listener hasn't updated it more recently.
          // For simplicity, we assign from snapshot; listener will handle subsequent changes.
          if (_currentVolume != snapshot.data!) {
             // This check avoids an unnecessary setState if the value is already what the snapshot provides,
             // potentially set by the listener just before this build.
             // However, direct assignment is also fine as FutureBuilder runs its builder.
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
              // Update UI immediately for responsiveness.
              // This also helps the listener to see the new state if it's triggered by storeVolumeValue,
              // preventing a re-entrant call to storeVolumeValue from the listener.
              setState(() {
                _currentVolume = newVolume;
              });
              // This call will change system volume and persist. It might trigger the listener.
              UserDataStorage.storeVolumeValue(newVolume);
            },
            icon: _currentVolume > 10
                ? const Icon(volumeUp, size: 70.0, color: CustomColors.textColor)
                : const Icon(volumeMute, size: 70.0, color: CustomColors.textColor),
          );
        } else {
          // Fallback for unexpected state, though should be covered by above
          return IconButton(
            icon: Icon(Icons.help_outline, size: 70.0, color: CustomColors.textColor.withOpacity(0.5)),
            onPressed: null,
          );
        }
      },
    );
  }
}

class VolumeSwitcher extends StatefulWidget {
  const VolumeSwitcher({super.key});

  @override
  State<VolumeSwitcher> createState() => _VolumeSwitcherState();
}
