import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_event_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_holiday_model.dart';

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

class LeaveDayDetailsCard extends GetView<LeaveController> {
  const LeaveDayDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.selectedDateItems;
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          appSize.size16.w,
          appSize.size16.h,
          appSize.size16.w,
          appSize.size8.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius16),
          boxShadow: [
            BoxShadow(
              color: appColors.blackColor.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.selectedDateLabel().isEmpty
                  ? 'Leaves'
                  : controller.selectedDateLabel(),
              style: fontStyles.font16Black700,
            ),
            SizedBox(height: appSize.size8.h),
            if (controller.holidaysLoading.value)
              Padding(
                padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
                child: Text(
                  'Leaves loading',
                  style: fontStyles.font14LightGrey400,
                ),
              )
            else if (items.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
                child: Text(
                  'No leaves on this date',
                  style: fontStyles.font14LightGrey400,
                ),
              )
            else
              ...List.generate(items.length, (index) {
                return _DayDetailRow(
                  item: items[index],
                  showDivider: index != items.length - 1,
                );
              }),
          ],
        ),
      );
    });
  }
}

class _DayDetailRow extends StatelessWidget {
  const _DayDetailRow({required this.item, this.showDivider = true});

  final CalendarDayDetail item;
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
                  color: item.accent,
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
                            Text(item.title, style: fontStyles.font14Black600),
                            SizedBox(height: appSize.size4.h),
                            Text(
                              item.dateLabel,
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
                          color: item.badgeBg,
                          borderRadius: BorderRadius.circular(appSize.radius8),
                        ),
                        child: Text(
                          item.badge,
                          style: fontStyles.font10LightGrey500.copyWith(
                            color: item.badgeText,
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
