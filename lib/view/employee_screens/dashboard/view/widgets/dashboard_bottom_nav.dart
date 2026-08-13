import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/dashboard/controller/controller.dart';

class DashboardBottomNav extends GetView<EmployeeDashboardController> {
  const DashboardBottomNav({super.key});

  static const _items = [
    Icons.home_outlined,
    Icons.calendar_today_outlined,
    Icons.description_outlined,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final barHeight = appSize.size64.h;
    final circleSize = appSize.size56.w;
    final notchRadius = circleSize / 2 + 6.w;
    final topOverlap = circleSize * 0.42;

    return Obx(() {
      final selected = controller.selectedNavIndex.value;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          appSize.size20.w,
          topOverlap,
          appSize.size20.w,
          appSize.size16.h,
        ),
        child: SizedBox(
          height: barHeight + topOverlap,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final itemWidth = width / _items.length;
              final targetCenterX = itemWidth * (selected + 0.5);

              return TweenAnimationBuilder<double>(
                tween: Tween(end: targetCenterX),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                builder: (context, circleCenterX, _) {
                  final circleCenterY = topOverlap;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: barHeight,
                        child: CustomPaint(
                          painter: _NotchedNavPainter(
                            notchCenterX: circleCenterX,
                            notchRadius: notchRadius,
                            cornerRadius: appSize.radius16,
                            barColor: appColors.whiteColor,
                            shadowColor: appColors.blackColor.withValues(
                              alpha: 0.12,
                            ),
                            glowColor: appColors.brandColor.withValues(
                              alpha: 0.18,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: circleCenterX - circleSize / 2 - 10.w,
                        top: circleCenterY - circleSize / 2 - 8.h,
                        child: IgnorePointer(
                          child: Container(
                            width: circleSize + 20.w,
                            height: circleSize + 20.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: appColors.brandColor.withValues(
                                    alpha: 0.28,
                                  ),
                                  blurRadius: 22,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: barHeight,
                        child: Row(
                          children: List.generate(_items.length, (index) {
                            final isSelected = selected == index;
                            return Expanded(
                              child: InkWell(
                                onTap: () => controller.onNavTap(index),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: SizedBox(
                                  height: barHeight,
                                  child: Center(
                                    child: AnimatedOpacity(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      opacity: isSelected ? 0 : 1,
                                      child: Icon(
                                        _items[index],
                                        color: appColors.mediumGreyColor,
                                        size: appSize.icon24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        left: circleCenterX - circleSize / 2,
                        top: circleCenterY - circleSize / 2,
                        child: GestureDetector(
                          onTap: () => controller.onNavTap(selected),
                          child: Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              color: appColors.brandColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: appColors.brandColor.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              _items[selected],
                              color: appColors.whiteColor,
                              size: appSize.icon26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }
}

class _NotchedNavPainter extends CustomPainter {
  _NotchedNavPainter({
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
  bool shouldRepaint(covariant _NotchedNavPainter oldDelegate) {
    return oldDelegate.notchCenterX != notchCenterX ||
        oldDelegate.notchRadius != notchRadius ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.barColor != barColor;
  }
}
