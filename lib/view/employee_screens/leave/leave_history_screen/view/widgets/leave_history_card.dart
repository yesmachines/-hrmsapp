import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/controller/controller.dart';

import '../../../model/leave_model.dart';
import '../../../model/leave_status_enum.dart';

class LeaveHistoryCard extends GetView<LeaveHistoryController> {
  const LeaveHistoryCard({super.key, required this.record});

  final LeaveModel record;

  @override
  Widget build(BuildContext context) {
    final typeStyle = controller.typeStyle(record.type);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size12.h),
      padding: EdgeInsets.all(appSize.size16.w),
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
          Row(
            children: [
              _Chip(
                label: record.type.leaveType,
                bg: typeStyle.bg,
                text: typeStyle.text,
              ),
              const Spacer(),
              _Chip(
                label: record.status.label,
                bg: controller.statusBg(record.status),
                text: controller.statusText(record.status),
              ),
            ],
          ),
          SizedBox(height: appSize.size14.h),
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: appColors.submittedBadgeBg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Icon(
                  Icons.calendar_month_outlined,
                  size: 16.sp,
                  color: appColors.brandColor,
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: appSize.size6.w,
                  children: [
                    Text(
                      'From ${controller.formatDate(record.fromDate)}',
                      style: fontStyles.font12LightGrey500.copyWith(
                        color: appColors.blackColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14.sp,
                      color: appColors.lightGreyColor,
                    ),
                    Text(
                      'To ${controller.formatDate(record.toDate)}',
                      style: fontStyles.font12LightGrey500.copyWith(
                        color: appColors.blackColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Divider(height: 1, color: appColors.strokeColor),
          SizedBox(height: appSize.size12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Applied On',
                      style: fontStyles.font10LightGrey500.copyWith(
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(height: appSize.size4.h),
                    Text(
                      controller.formatDate(record.appliedOn),
                      style: fontStyles.font12LightGrey500.copyWith(
                        color: appColors.blackColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              _ActionButton(
                icon: Icons.visibility_outlined,
                label: 'View',
                onTap: () => controller.onView(record),
              ),
              if (record.canEdit) ...[
                SizedBox(width: appSize.size8.w),
                _ActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () => controller.onEdit(record),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.bg, required this.text});

  final String label;
  final Color bg;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size10.w,
        vertical: appSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(appSize.radius8),
      ),
      child: Text(
        label,
        style: fontStyles.font10LightGrey500.copyWith(
          color: text,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size12.w,
          vertical: appSize.size8.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(
            color: appColors.brandColor.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: appColors.brandColor),
            SizedBox(width: appSize.size4.w),
            Text(label, style: fontStyles.font12Brand600),
          ],
        ),
      ),
    );
  }
}
