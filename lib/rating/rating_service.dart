import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atloud/rating/rate_us_dialog.dart';

class RatingService {
  static const String _appLaunchCountKey = 'appLaunchCount';
  static const String _hasRatedKey = 'hasRated';

  Future<void> incrementAppLaunchCount() async {
    final prefs = await SharedPreferences.getInstance();
    int appLaunchCount = prefs.getInt(_appLaunchCountKey) ?? 0;
    await prefs.setInt(_appLaunchCountKey, appLaunchCount + 1);
  }

  Future<bool> shouldShowRatingDialog() async {
    final prefs = await SharedPreferences.getInstance();
    int appLaunchCount = prefs.getInt(_appLaunchCountKey) ?? 0;
    print('App launch count: $appLaunchCount');
    bool hasRated = prefs.getBool(_hasRatedKey) ?? false;
    print('Has rated: $hasRated');

    if (hasRated) {
      return false;
    }

    return [3, 6, 9].contains(appLaunchCount);
  }

  Future<void> setHasRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasRatedKey, true);
  }

  Future<int> getAppLaunchCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_appLaunchCountKey) ?? 0;
  }

  void showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RateUsDialog(),
    );
  }

  Future<void> openStoreForRating() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
