import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class TravelCard extends StatelessWidget {
  const TravelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(appSize.radius20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appColors.travelBlue, appColors.travelBlueDark],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _MapDotsPainter()),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are travelling today to Germany',
                style: fontStyles.font16White600,
              ),
              SizedBox(height: appSize.size6.h),
              Text(
                'Hussain Sajwani Visiting Today',
                style: fontStyles.font12White500.copyWith(
                  color: appColors.whiteColor.withValues(alpha: 0.85),
                ),
              ),
              SizedBox(height: appSize.size16.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: appSize.size16.w,
                      vertical: appSize.size10.h,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.whiteColor,
                      borderRadius: BorderRadius.circular(appSize.radius60),
                    ),
                    child: Text(
                      'View Itinerary',
                      style: fontStyles.font14Brand700,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.flight_takeoff_rounded,
                    color: appColors.whiteColor.withValues(alpha: 0.9),
                    size: appSize.icon32,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double y = 8; y < size.height; y += 18) {
      final path = Path();
      for (double x = 0; x < size.width; x += 16) {
        final dy = math.sin(x / 24) * 4;
        if (x == 0) {
          path.moveTo(x, y + dy);
        } else {
          path.lineTo(x, y + dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
