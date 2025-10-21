import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:atloud/rating/rate_us_dialog.dart';
import 'package:atloud/shared/user_data_storage.dart';

class RatingService {
  Future<void> incrementAppLaunchCount() async {
    int appLaunchCount = await UserDataStorage.appLaunchCount();
    UserDataStorage.storeAppLaunchCount(appLaunchCount + 1);
  }

  Future<bool> shouldShowRatingDialog() async {
    int appLaunchCount = await UserDataStorage.appLaunchCount();
    bool hasRated = await UserDataStorage.hasRated();

    if (hasRated) {
      return false;
    }

    return [3, 6, 9].contains(appLaunchCount);
  }

  Future<int> getAppLaunchCount() async {
    return await UserDataStorage.appLaunchCount();
  }

  void showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RateUsDialog(),
    );
  }

  Future<void> openStoreForRating() async {
    final InAppReview inAppReview = InAppReview.instance;
    await inAppReview.openStoreListing(appStoreId: 'pl.btsoftware.atloud');
  }
}
