import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/dashboard/controller/controller.dart';

class HomeScreenHeader extends GetView<EmployeeDashboardController> {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: fontStyles.font14LightGrey400.copyWith(
                  color: appColors.blackColor,
                ),
              ),
              Obx(
                () => Text(
                  '${controller.employeeName.value} 👋',
                  style: fontStyles.font28Black700,
                ),
              ),
              SizedBox(height: appSize.size6.h),
              Obx(
                () => Text(
                  controller.dateLabel.value,
                  style: fontStyles.font12LightGrey500,
                ),
              ),
              SizedBox(height: appSize.size8.h),
              Text(
                'HERE IS WHAT IS HAPPENING TODAY',
                style: fontStyles.font12Brand600,
              ),
            ],
          ),
        ),
        Icon(
          Icons.work_outline_rounded,
          color: appColors.mediumGreyColor,
          size: appSize.icon24,
        ),
        SizedBox(width: appSize.size12.w),
        Badge(
          child: Icon(
            Icons.notifications_none_rounded,
            color: appColors.mediumGreyColor,
            size: appSize.icon24,
          ),
        ),
      ],
    );
  }
}
