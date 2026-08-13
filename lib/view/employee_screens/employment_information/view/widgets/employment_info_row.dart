import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

import '../../controller/controller.dart';

class EmploymentInfoRow extends StatelessWidget {
  const EmploymentInfoRow({
    super.key,
    required this.field,
    this.showDivider = true,
  });

  final EmploymentInfoField field;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: appSize.size14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                field.icon,
                color: appColors.brandColor,
                size: appSize.icon20,
              ),
              SizedBox(width: appSize.size12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field.label, style: fontStyles.font10LightGrey500),
                    SizedBox(height: appSize.size6.h),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            field.value,
                            style: fontStyles.font14Black600,
                          ),
                        ),
                        if (field.badgeText != null) ...[
                          SizedBox(width: appSize.size8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: appSize.size10.w,
                              vertical: appSize.size4.h,
                            ),
                            decoration: BoxDecoration(
                              color: appColors.activeBadgeBg,
                              borderRadius: BorderRadius.circular(
                                appSize.radius60,
                              ),
                            ),
                            child: Text(
                              field.badgeText!,
                              style: fontStyles.font10LightGrey500.copyWith(
                                color: appColors.activeBadgeText,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: appColors.strokeColor.withValues(alpha: 0.7),
          ),
      ],
    );
  }
}
