import 'dart:math' as math;
import 'package:flutter/material.dart';

class TimerProgressPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final Color backgroundColor;
  final Color completedColor;
  final double strokeWidth;
  final bool isCompleted;

  TimerProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.completedColor,
    required this.strokeWidth,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - strokeWidth / 2;
    const startAngle = -math.pi / 2; // Start from the top

    // Background track paint
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw the background track (full circle)
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress or Completed paint
    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Makes the ends rounded

    if (isCompleted) {
      // Draw full circle in completed color
      progressPaint.color = completedColor;
      canvas.drawCircle(center, radius, progressPaint);
    } else {
      // Draw progress arc
      progressPaint.color = progressColor;
      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TimerProgressPainter oldDelegate) {
    return progress != oldDelegate.progress ||
           isCompleted != oldDelegate.isCompleted ||
           progressColor != oldDelegate.progressColor ||
           backgroundColor != oldDelegate.backgroundColor ||
           completedColor != oldDelegate.completedColor ||
           strokeWidth != oldDelegate.strokeWidth;
  }
}
