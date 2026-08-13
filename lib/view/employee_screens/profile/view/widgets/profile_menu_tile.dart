import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/profile/controller/controller.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.item,
    this.onTap,
  });

  final ProfileMenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius16),
      child: Container(
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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: appSize.size44.w,
              height: appSize.size44.w,
              decoration: BoxDecoration(
                color: item.backgroundColor,
                borderRadius: BorderRadius.circular(appSize.radius12),
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: appSize.icon24,
              ),
            ),
            SizedBox(width: appSize.size14.w),
            Expanded(
              child: Text(item.title, style: fontStyles.font14Black600),
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
