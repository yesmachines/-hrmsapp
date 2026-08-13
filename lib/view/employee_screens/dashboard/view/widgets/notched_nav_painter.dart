import 'package:flutter/material.dart';

class NotchedNavPainter extends CustomPainter {
  NotchedNavPainter({
    required this.notchCenterX,
    required this.notchRadius,
    required this.cornerRadius,
    required this.barColor,
    required this.shadowColor,
    required this.glowColor,
  });

  final double notchCenterX;
  final double notchRadius;
  final double cornerRadius;
  final Color barColor;
  final Color shadowColor;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = cornerRadius;
    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(notchCenterX - notchRadius, 0)
      ..arcToPoint(
        Offset(notchCenterX + notchRadius, 0),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: Radius.circular(radius),
      )
      ..lineTo(radius, size.height)
      ..arcToPoint(
        Offset(0, size.height - radius),
        radius: Radius.circular(radius),
      )
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius))
      ..close();

    canvas.drawShadow(path, shadowColor, 12, false);

    final glowPaint = Paint()
      ..color = glowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(notchCenterX, 0), notchRadius * 0.9, glowPaint);

    canvas.drawPath(path, Paint()..color = barColor);
  }

  @override
  bool shouldRepaint(covariant NotchedNavPainter oldDelegate) {
    return oldDelegate.notchCenterX != notchCenterX ||
        oldDelegate.notchRadius != notchRadius ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.barColor != barColor;
  }
}
