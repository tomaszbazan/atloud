import 'package:flutter/material.dart';

import '../foreground_task/timer_task.dart';
import '../l10n/app_localizations.dart';

class NextAnnouncementWidget extends StatelessWidget {
  final ValueNotifier<Object?> taskDataListenable;

  const NextAnnouncementWidget({
    super.key,
    required this.taskDataListenable,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ValueListenableBuilder(
      valueListenable: taskDataListenable,
      builder: (context, data, _) {
        String? nextAnnouncementText;

        if (data is Map<String, dynamic>) {
          nextAnnouncementText = data[TimerTaskHandler.returnedNextAnnouncement];
        }

        if (nextAnnouncementText != null) {
          return Positioned(
            bottom: 20.0,
            right: 20.0,
            child: Text(
              '${localizations.nextAnnouncementIn} $nextAnnouncementText',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.right,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}