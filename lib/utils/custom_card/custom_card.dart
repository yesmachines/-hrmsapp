import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.radius,
    this.fillColor,
  });

  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double? radius;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.symmetric(horizontal: appSize.size2.w),
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: appSize.size12.w,
            vertical: appSize.size8.h,
          ),
      decoration: ShapeDecoration(
        color: fillColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? appSize.radius4),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 2,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
