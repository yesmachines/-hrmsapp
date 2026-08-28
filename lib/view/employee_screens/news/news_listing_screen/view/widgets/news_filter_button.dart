import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

class NewsFilterButton extends StatelessWidget {
  const NewsFilterButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.onClear,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          border: Border.all(
            color: isActive
                ? appColors.brandColor.withValues(alpha: 0.45)
                : appColors.strokeColor,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: fontStyles.font12LightGrey500.copyWith(
                  color: isActive
                      ? appColors.brandColor
                      : appColors.mediumGreyColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ),
            if (onClear != null)
              InkWell(
                onTap: onClear,
                borderRadius: BorderRadius.circular(appSize.radius60),
                child: Icon(
                  Icons.close_rounded,
                  color: appColors.lightGreyColor,
                  size: 16.sp,
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: appColors.lightGreyColor,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
