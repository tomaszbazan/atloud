import 'package:atloud/timer/timer_ring_painter.dart';
import 'package:flutter/material.dart';

class TimerRing extends StatelessWidget {
  final Duration? duration;
  final Duration? startingTime;
  final Widget child;

  const TimerRing({
    super.key,
    required this.duration,
    required this.startingTime,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal ring size - use 70% of screen width or height, whichever is smaller
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        
        // Use the smaller dimension to ensure ring fits on screen
        final smallerDimension = screenWidth < screenHeight ? screenWidth : screenHeight;
        final ringSize = smallerDimension * 0.7; // Use 70% of the smaller dimension
        final textSize = smallerDimension * 0.85; // Use 85% of the smaller dimension

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: ringSize,
              height: ringSize,
              child: CustomPaint(
                painter: TimerRingPainter(
                  progress: _calculateProgress(),
                  isFinished: isFinished,
                  isDarkTheme: isDarkTheme,
                ),
              ),
            ),
            SizedBox(
              height: ringSize,
              width: textSize,
              child: child,
            ),
          ],
        );
      }
    );
  }

  bool get isFinished => duration != null && startingTime != null && (duration!.isNegative || duration!.inSeconds == 0);

  double _calculateProgress() {
    if (duration == null || startingTime == null || startingTime!.inSeconds == 0) {
      return 1.0;
    }

    // When timer is finished but not in "alarm" state yet
    if (duration!.inSeconds <= 0 && !isFinished) {
      return 0.0;
    }

    // When timer is active
    final totalSeconds = startingTime!.inSeconds;
    final remainingSeconds = duration!.inSeconds;

    // Invert the progress calculation so that it decreases as time passes
    // 1.0 means full ring (start), 0.0 means empty ring (end)
    return remainingSeconds / totalSeconds;
  }
}
