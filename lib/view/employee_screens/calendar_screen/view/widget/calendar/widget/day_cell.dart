import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../main.dart';

class DayCell extends GetView {
  const DayCell({
    super.key,
    required this.rangeStart,
    required this.rangeEnd,
    required this.selected,
    required this.today,
    required this.hasEvent,
    required this.hasLeave,
    this.rangeColor, required this.day,
  });

  final DateTime day;
  final bool rangeStart;
  final bool rangeEnd;
  final bool selected;
  final bool today;
  final bool hasEvent;
  final bool hasLeave;
  final Color? rangeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (rangeColor != null)
          Container(
            height: 34.h,
            margin: EdgeInsets.only(
              left: rangeStart ? 8.w : 0,
              right: rangeEnd ? 8.w : 0,
            ),
            decoration: BoxDecoration(
              color: rangeColor,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(rangeStart ? appSize.radius60 : 0),
                right: Radius.circular(rangeEnd ? appSize.radius60 : 0),
              ),
            ),
          ),
        Container(
          width: 34.w,
          height: 34.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? appColors.brandColor
                : today
                ? appColors.brandColor.withValues(alpha: 0.12)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${day.day}',
            style: fontStyles.font12LightGrey500.copyWith(
              letterSpacing: 0,
              fontWeight: selected || today ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? appColors.whiteColor
                  : today
                  ? appColors.brandColor
                  : appColors.blackColor,
            ),
          ),
        ),
        if (hasEvent)
          Positioned(
            bottom: 1.h,
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: hasLeave
                    ? appColors.orangeColor
                    : selected
                    ? appColors.whiteColor
                    : appColors.brandColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
