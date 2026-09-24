import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class DocumentFilterChip extends StatelessWidget {
  const DocumentFilterChip({
    super.key,
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius60),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size12.w,
          vertical: appSize.size8.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius60),
          border: Border.all(color: appColors.strokeColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: fontStyles.font12LightGrey500.copyWith(
                letterSpacing: 0,
                color: appColors.mediumGreyColor,
              ),
            ),
            SizedBox(width: appSize.size4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: appSize.icon18,
              color: appColors.lightGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
