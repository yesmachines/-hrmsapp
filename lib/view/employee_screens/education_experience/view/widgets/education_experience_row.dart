import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

import '../../controller/controller.dart';

class EducationExperienceRow extends StatelessWidget {
  const EducationExperienceRow({
    super.key,
    required this.field,
    this.showDivider = true,
  });

  final EducationExperienceField field;
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
                    Text(field.value, style: fontStyles.font14Black600),
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
