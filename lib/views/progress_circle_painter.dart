import 'package:flutter/material.dart';

class ProgressCirclePainter extends CustomPainter {
  final double percentage;
  final BuildContext context;

  ProgressCirclePainter(this.percentage, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final strokeWidth = 4.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final backgroundPaint = Paint()
      ..color = isDark ? Colors.grey.shade700 : Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = getColorForPercentage(percentage, isDark)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * 3.141592653589793 * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  Color getColorForPercentage(double percentage, bool isDark) {
    if (percentage < 50) {
      return isDark ? Colors.red.shade300 : Colors.red;
    }
    if (percentage < 75) {
      return isDark ? Colors.orange.shade300 : Colors.orange;
    }
    return isDark ? Colors.green.shade400 : Colors.green.shade800;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
