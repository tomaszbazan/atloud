import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:atloud/theme/colors.dart';

class TimerRingPainter extends CustomPainter {
  final double progress;
  final bool isFinished;
  final bool isDarkTheme;
  
  TimerRingPainter({
    required this.progress,
    required this.isFinished,
    required this.isDarkTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 1.6;
    
    final paint = Paint()
      ..color = isFinished ? CustomColors.alarmRingColor : (isDarkTheme ? CustomColors.darkTimerRingColor : CustomColors.timerRingColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;

    if (isFinished) {
      canvas.drawCircle(center, radius, paint);
      return;
    }
    
    // Draw nothing if progress is 0 (timer ended but alarm not yet triggered)
    if (progress <= 0.0) {
      return;
    }
    
    const startAngle = 3 * math.pi / 2; // 12 o'clock position (in positive angle system)
    final sweepAngle = -2 * math.pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isFinished != isFinished || oldDelegate.isDarkTheme != isDarkTheme;
  }
}