import 'package:atloud/l10n/app_localizations.dart';
import 'package:atloud/onboarding/pages/onboarding_page_1.dart';
import 'package:atloud/onboarding/pages/onboarding_page_2.dart';
import 'package:atloud/onboarding/pages/onboarding_page_3.dart';
import 'package:atloud/onboarding/pages/onboarding_page_4.dart';
import 'package:atloud/onboarding/pages/onboarding_page_5.dart';
import 'package:atloud/shared/user_data_storage.dart';
import 'package:atloud/theme/colors.dart';
import 'package:atloud/theme/fonts.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final Future<void> Function() onComplete;

  const OnboardingScreen({required this.onComplete, super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await UserDataStorage.storeHasCompletedOnboarding(true);
    await widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackgroundColor : CustomColors.lightBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? CustomColors.darkSecondColor : CustomColors.secondColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: const [
                      OnboardingPage1(),
                      OnboardingPage2(),
                      OnboardingPage3(),
                      OnboardingPage4(),
                      OnboardingPage5(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? CustomColors.darkSecondColor : CustomColors.secondColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.onboardingNext,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: CustomFonts.openSans.value,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
