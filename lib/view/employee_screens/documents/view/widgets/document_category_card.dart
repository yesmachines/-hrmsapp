import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/documents/controller/controller.dart';

import '../../service/model/document_category.dart';

class DocumentCategoryCard extends StatelessWidget {
  const DocumentCategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  final DocumentCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(appSize.size16.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    category.title,
                    style: fontStyles.font14Black600.copyWith(
                      color: category.accentColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: category.accentColor,
                  size: appSize.icon24,
                ),
              ],
            ),
            SizedBox(height: appSize.size10.h),
            Text(
              '${category.items.join(' • ')} •',
              style: fontStyles.font12LightGrey500.copyWith(
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            SizedBox(height: appSize.size14.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size10.w,
                vertical: appSize.size6.h,
              ),
              decoration: BoxDecoration(
                color: category.accentColor,
                borderRadius: BorderRadius.circular(appSize.radius8),
              ),
              child: Text(
                '${category.count} DOCUMENTS',
                style: fontStyles.font10White400.copyWith(
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
