import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/view/employee_screens/letter_requests/controller/controller.dart';

Future<dynamic> showNocRequestDetailsBottomSheet({
  required LetterRequest request,
}) {
  return customBottomSheet(
    title: '${request.title} Request Details',
    child: Column(
      children: [
        _DetailCard(
          label: 'PURPOSE',
          value: request.purpose ?? '-',
        ),
        SizedBox(height: appSize.size12.h),
        _DetailCard(
          label: 'DETAILS',
          value: request.details ?? '-',
        ),
        SizedBox(height: appSize.size12.h),
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                label: 'APPLIED DATE',
                value: request.applyDate,
              ),
            ),
            SizedBox(width: appSize.size12.w),
            Expanded(
              child: _DetailCard(
                label: 'STATUS',
                value: request.status,
                valueColor: appColors.activeBadgeText,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size14.w),
      decoration: BoxDecoration(
        color: appColors.scaffoldGreyColor,
        borderRadius: BorderRadius.circular(appSize.radius12),
        border: Border.all(color: appColors.strokeColor.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: fontStyles.font10LightGrey500),
          SizedBox(height: appSize.size8.h),
          Text(
            value,
            style: fontStyles.font14Black600.copyWith(
              color: valueColor ?? appColors.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
