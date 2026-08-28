import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_event_model.dart';

class LeaveEventCard extends GetView<LeaveController> {
  const LeaveEventCard({
    super.key,
    required this.event,
    this.showDivider = true,
  });

  final LeaveEventModel event;
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
                  color: event.accentColor,
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
                              controller.eventDateLabel(event),
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
                          color: controller.badgeBg(event.badge),
                          borderRadius: BorderRadius.circular(appSize.radius8),
                        ),
                        child: Text(
                          controller.badgeLabel(event.badge),
                          style: fontStyles.font10LightGrey500.copyWith(
                            color: controller.badgeText(event.badge),
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
