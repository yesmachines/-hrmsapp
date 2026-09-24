import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../controller/controller.dart';
import 'event_tile.dart';

class SelectedDayEvents extends GetView<CalenderController> {
  const SelectedDayEvents({super.key});

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
                  ? 'Events'
                  : controller.selectedDateLabel(),
              style: fontStyles.font16Black700,
            ),
            SizedBox(height: appSize.size8.h),
            if (controller.holidaysLoading.value)
              Padding(
                padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
                child: Text(
                  'Events loading',
                  style: fontStyles.font14LightGrey400,
                ),
              )
            else if (items.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
                child: Text(
                  'No Events on this date',
                  style: fontStyles.font14LightGrey400,
                ),
              )
            else
              ...List.generate(items.length, (index) {
                return EventTile(
                  event: items[index],
                  showDivider: index != items.length - 1,
                );
              }),
          ],
        ),
      );
    });
  }
}
