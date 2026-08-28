import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/main.dart';

class ApplyLeaveUploadBox extends StatelessWidget {
  const ApplyLeaveUploadBox({
    super.key,
    required this.title,
    required this.files,
    required this.onTap,
    required this.onRemove,
  });

  final String title;
  final List<XFile> files;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: fontStyles.font14Black600),
        SizedBox(height: appSize.size10.h),
        if (files.isNotEmpty)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(appSize.radius16),
                child: Image.file(
                  File(files.first.path),
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(appSize.size4.w),
                    decoration: BoxDecoration(
                      color: appColors.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 14.sp,
                      color: appColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          CustomPaint(
            painter: _DashedBorderPainter(
              color: appColors.brandColor.withValues(alpha: 0.45),
              radius: appSize.radius16,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(appSize.radius16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: appSize.size24.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: appColors.brandColor,
                      size: 28.sp,
                    ),
                    SizedBox(height: appSize.size8.h),
                    Text('Tap to Upload', style: fontStyles.font14Brand700),
                    SizedBox(height: appSize.size4.h),
                    Text(
                      'Supported: PDF, JPG, PNG',
                      style: fontStyles.font12LightGrey500.copyWith(
                        letterSpacing: 0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    final dashed = _dashPath(path, dashLength: 6, gapLength: 4);
    canvas.drawPath(dashed, paint);
  }

  Path _dashPath(Path source, {required double dashLength, required double gapLength}) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        dashed.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + gapLength;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
