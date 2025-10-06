import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class NextAnnouncementWidget extends StatelessWidget {
  final int? period;

  const NextAnnouncementWidget({
    super.key,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    if (period == null) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context)!;
    return Positioned(
      bottom: 20.0,
      right: 20.0,
      child: Text(
        localizations.nextAnnouncementIn(period.toString()),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}