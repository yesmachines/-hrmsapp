import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../main.dart';
import '../../../leave/leave_screen/service/model/leave_holiday_model.dart';

class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event, required this.showDivider});

  final CalendarDayDetail event;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3.w,
                margin: EdgeInsets.symmetric(vertical: appSize.size4.h),
                decoration: BoxDecoration(
                  color: event.accent,
                  borderRadius: BorderRadius.circular(appSize.radius60),
                ),
              ),
              SizedBox(width: appSize.size12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: appSize.size12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title, style: fontStyles.font14Black600),
                            SizedBox(height: appSize.size4.h),
                            Text(
                              event.dateLabel,
                              style: fontStyles.font12LightGrey500.copyWith(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: appSize.size10.w,
                          vertical: appSize.size4.h,
                        ),
                        decoration: BoxDecoration(
                          color: event.badgeBg,
                          borderRadius: BorderRadius.circular(appSize.radius8),
                        ),
                        child: Text(
                          event.badge,
                          style: fontStyles.font10LightGrey500.copyWith(
                            color: event.badgeText,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: appColors.strokeColor.withValues(alpha: 0.7),
          ),
      ],
    );
  }
}
