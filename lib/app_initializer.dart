import 'package:atloud/foreground_task/foreground_task_initializer.dart';
import 'package:atloud/onboarding/onboarding_screen.dart';
import 'package:atloud/rating/rating_service.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class AppInitializer extends StatefulWidget {
  final RatingService ratingService;

  const AppInitializer({required this.ratingService, super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _hasCompletedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final hasCompleted = await UserDataStorage.hasCompletedOnboarding();
    if (hasCompleted) {
      _initializeForegroundServices();
      await widget.ratingService.incrementAppLaunchCount();
    }
    setState(() {
      _hasCompletedOnboarding = hasCompleted;
      _isLoading = false;
    });
  }

  void _initializeForegroundServices() {
    FlutterForegroundTask.initCommunicationPort();
    ForegroundTaskInitializer.initService();
  }

  Future<void> _onOnboardingComplete() async {
    _initializeForegroundServices();
    await widget.ratingService.incrementAppLaunchCount();
    setState(() {
      _hasCompletedOnboarding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasCompletedOnboarding) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }

    return const TimerPage(isTimerPage: false);
  }
}
