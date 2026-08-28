import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_event_model.dart';

class LeaveActionTile extends StatelessWidget {
  const LeaveActionTile({
    super.key,
    required this.action,
    required this.onTap,
  });

  final LeaveActionModel action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius16),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: appSize.size10.h),
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
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
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(appSize.radius12),
              ),
              child: Icon(action.icon, color: action.color, size: 22.sp),
            ),
            SizedBox(width: appSize.size12.w),
            Expanded(
              child: Text(
                action.title,
                style: fontStyles.font14Black600.copyWith(color: action.color),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: appColors.lightGreyColor,
              size: appSize.icon24,
            ),
          ],
        ),
      ),
    );
  }
}
