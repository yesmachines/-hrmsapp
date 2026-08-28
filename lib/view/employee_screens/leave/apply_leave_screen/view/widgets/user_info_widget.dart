import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/controller/controller.dart';

import '../../../../../../main.dart';

class UserInfoWidget extends GetView<ApplyLeaveController> {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(() {
            return Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColors.profileIconBlueBg,
                border: Border.all(
                  color: appColors.whiteColor,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: appColors.blackColor.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                image:
                controller
                    .leaveMetaData
                    .value!
                    .employee
                    .imageUrl
                    .isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(
                    controller
                        .leaveMetaData
                        .value!
                        .employee
                        .imageUrl,
                  ),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child:
              controller
                  .leaveMetaData
                  .value!
                  .employee
                  .imageUrl
                  .isEmpty
                  ? Icon(
                Icons.person_rounded,
                size: 42.sp,
                color: appColors.brandColor,
              )
                  : null,
            );
          }),
          SizedBox(height: appSize.size12.h),
          Obx(
                () => Text(
              controller.leaveMetaData.value!.employee.name,
              style: fontStyles.font16Black700,
            ),
          ),
        ],
      ),
    );
  }
}
