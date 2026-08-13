import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';

class SourceOption extends StatelessWidget {
  const SourceOption({super.key,
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
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size16.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: appColors.scaffoldGreyColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(color: appColors.strokeColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: appColors.brandColor, size: appSize.size22.sp),
            SizedBox(width: appSize.size12.w),
            Text(label, style: fontStyles.font14Black600),
          ],
        ),
      ),
    );
  }
}
