import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class ShimmerEffect extends StatelessWidget {
  ShimmerEffect.rectangle({
    super.key,
    required this.width,
    required this.height,
    this.decoration,
    this.baseColor,
    this.child,
    this.highlightColor,
  }) : shapeDecoration = RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(appSize.radius8)),
       );

  ShimmerEffect.circle({
    super.key,
    required this.width,
    required this.height,
    this.decoration,
    this.baseColor,
    this.child,
    this.highlightColor,
    required this.shapeDecoration,
  });

  double? width;
  double? height;
  Widget? child;
  BoxDecoration? decoration;
  Color? baseColor;
  Color? highlightColor;
  ShapeBorder shapeDecoration;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:
          baseColor ?? appColors.mediumGreyColor.withValues(alpha: 0.5),
      highlightColor:
          highlightColor ?? appColors.mediumGreyColor.withValues(alpha: 0.6),
      enabled: true,
      child:
          child ??
          Container(
            width: width,
            height: height,
            decoration:
                decoration ??
                ShapeDecoration(color: Colors.white, shape: shapeDecoration),
          ),
    );
  }
}
