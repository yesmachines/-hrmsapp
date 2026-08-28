import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitCard extends GetView<VisitsController> {
  const VisitCard({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    final showDate = visit.tab != VisitTab.today;

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
                label: visit.type.label,
                bg: visit.tab == VisitTab.history &&
                        visit.status != VisitStatus.approved
                    ? appColors.scaffoldGreyColor
                    : appColors.submittedBadgeBg,
                text: visit.tab == VisitTab.history &&
                        visit.status != VisitStatus.approved
                    ? appColors.mediumGreyColor
                    : appColors.submittedBadgeText,
              ),
              const Spacer(),
              _Chip(
                label: visit.status.label,
                bg: controller.statusBg(visit.status),
                text: controller.statusText(visit.status),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Text(visit.title, style: fontStyles.font16Black700),
          SizedBox(height: appSize.size10.h),
          if (showDate) ...[
            _MetaRow(
              icon: Icons.calendar_month_outlined,
              text: controller.formatDate(visit.date),
            ),
            SizedBox(height: appSize.size6.h),
          ],
          _MetaRow(icon: Icons.access_time_rounded, text: visit.time),
          SizedBox(height: appSize.size6.h),
          _MetaRow(icon: Icons.location_on_outlined, text: visit.location),
          SizedBox(height: appSize.size12.h),
          Divider(height: 1, color: appColors.strokeColor),
          SizedBox(height: appSize.size12.h),
          _LabeledValue(label: 'PURPOSE', value: visit.purpose),
          SizedBox(height: appSize.size10.h),
          _LabeledValue(label: 'ASSIGNED TASK', value: visit.assignedTask),
          SizedBox(height: appSize.size12.h),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => controller.onViewVisit(visit),
              borderRadius: BorderRadius.circular(appSize.radius8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View', style: fontStyles.font14Brand700),
                  SizedBox(width: appSize.size4.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.sp,
                    color: appColors.brandColor,
                  ),
                ],
              ),
            ),
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

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: appColors.lightGreyColor),
        SizedBox(width: appSize.size6.w),
        Text(
          text,
          style: fontStyles.font12LightGrey500.copyWith(
            color: appColors.blackColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: fontStyles.font10LightGrey500.copyWith(
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: appSize.size4.h),
        Text(value, style: fontStyles.font14Black600),
      ],
    );
  }
}
