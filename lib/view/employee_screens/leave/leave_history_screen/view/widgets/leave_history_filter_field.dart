import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class LeaveHistoryFilterField extends StatelessWidget {
  const LeaveHistoryFilterField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.leading,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? leading;

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
        SizedBox(height: appSize.size6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(appSize.radius12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: appSize.size12.w,
              vertical: appSize.size12.h,
            ),
            decoration: BoxDecoration(
              color: appColors.whiteColor,
              borderRadius: BorderRadius.circular(appSize.radius12),
              border: Border.all(color: appColors.strokeColor),
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: appSize.size6.w),
                ],
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: fontStyles.font12LightGrey500.copyWith(
                      color: appColors.blackColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: appColors.lightGreyColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
