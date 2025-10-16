import 'package:atloud/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/rating/rating_service.dart';
import 'package:atloud/feedback/feedback_page.dart';

class RateUsDialog extends StatefulWidget {
  const RateUsDialog({super.key});

  @override
  State<RateUsDialog> createState() => _RateUsDialogState();
}

class _RateUsDialogState extends State<RateUsDialog> {
  int _rating = 0;
  final RatingService _ratingService = RatingService();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final customColors = theme.brightness == Brightness.dark ? CustomColors.darkSecondColor : CustomColors.secondColor;

    return FutureBuilder<int>(
      future: _ratingService.getAppLaunchCount(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final launchCount = snapshot.data!;
        String title;
        String content;

        if (launchCount <= 3) {
          title = localizations.ratingDialogTitle1;
          content = localizations.ratingDialogContent1;
        } else if (launchCount <= 6) {
          title = localizations.ratingDialogTitle2;
          content = localizations.ratingDialogContent2;
        } else {
          title = localizations.ratingDialogTitle3;
          content = localizations.ratingDialogContent3;
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: customColors, width: 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade400),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  if (launchCount <= 3) ...[
                    const SizedBox(width: 8),
                    Image.asset('assets/icons/clock.png', height: 20),
                  ]
                ],
              ),
              const SizedBox(height: 16),
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                localizations.ratingChoose,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: index < _rating ? customColors : Colors.grey,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customColors,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _rating > 0 ? _submit : null,
                  child: Text(
                    localizations.ratingSubmit,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit() {
    _ratingService.setHasRated();
    Navigator.of(context).pop();

    if (_rating == 5) {
      _ratingService.openStoreForRating();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => FeedbackPage()),
      );
    }
  }
}
