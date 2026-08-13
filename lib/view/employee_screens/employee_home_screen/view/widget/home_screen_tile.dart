import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/dashboard/controller/controller.dart';

import '../../service/model/home_screen_tile_model.dart';

class HomeScreenTile extends StatelessWidget {
  const HomeScreenTile({super.key, required this.data, this.onTap});

  final HomeScreenTileModel data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius20),
      child: Container(
        constraints: BoxConstraints(minHeight: 120.h),
        padding: EdgeInsets.all(appSize.size14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appSize.radius20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [data.startColor, data.endColor],
          ),
          boxShadow: [
            BoxShadow(
              color: data.startColor.withValues(alpha: 0.28),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(data.icon, color: appColors.whiteColor, size: appSize.icon24),
            SizedBox(height: appSize.size10.h),
            Text(data.title, style: fontStyles.font14White600),
            SizedBox(height: appSize.size6.h),
            ...data.lines.map(
              (line) => Padding(
                padding: EdgeInsets.only(bottom: appSize.size2.h),
                child: Text(
                  line,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: fontStyles.font10White400,
                ),
              ),
            ),
            if (data.progress != null) ...[
              SizedBox(height: appSize.size8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(appSize.radius8),
                child: LinearProgressIndicator(
                  value: data.progress,
                  minHeight: appSize.size6.h,
                  backgroundColor: appColors.whiteColor.withValues(alpha: 0.25),
                  valueColor: AlwaysStoppedAnimation(appColors.whiteColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
