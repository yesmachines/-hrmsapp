import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class CustomerDivider extends StatelessWidget {
  const CustomerDivider({
    super.key,
    this.thickness,
    this.color,
    this.titleColor,
    this.title,
    this.padding,
  });

  final String? title;
  final double? thickness;
  final Color? color;
  final Color? titleColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(right: appSize.size6.w),
            child: Text(
              title!,
              style: fontStyles.font14LightGrey400.copyWith(
                color: titleColor,
                fontSize: appSize.font10,
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Divider(
              thickness: thickness ?? 0.5.h,
              color: color ?? appColors.lightGreyColor,
            ),
          ),
        ),
      ],
    );
  }
}
