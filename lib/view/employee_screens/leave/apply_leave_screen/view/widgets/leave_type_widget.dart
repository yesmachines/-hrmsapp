import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/controller/controller.dart';

import '../../../../../../main.dart';

class LeaveTypeWidget extends GetView<ApplyLeaveController> {
  const LeaveTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: controller.onLeaveTypeTap,
        borderRadius: BorderRadius.circular(appSize.radius12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: appSize.size14.w,
            vertical: appSize.size14.h,
          ),
          decoration: BoxDecoration(
            color: appColors.whiteColor,
            borderRadius: BorderRadius.circular(appSize.radius12),
            border: Border.all(color: appColors.strokeColor),
          ),
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: appColors.brandColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: Text(
                  controller.selectedLeaveType.value?.leaveName ??
                      "Select leave type",
                  style: fontStyles.font14Black600.copyWith(
                    color: controller.selectedLeaveType.value == null
                        ? appColors.lightGreyColor
                        : null,
                    fontWeight: controller.selectedLeaveType.value == null
                        ? .w400
                        : null,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: appColors.lightGreyColor,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
