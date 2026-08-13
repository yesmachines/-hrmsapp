import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';

import '../../controller/controller.dart';
import '../../service/model/idea_data_model.dart';

class IdeaCard extends GetView<IdeasController> {
  const IdeaCard({super.key, required this.idea});

  final IdeaItem idea;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size8.h),
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size10.w,
                  vertical: appSize.size4.h,
                ),
                decoration: BoxDecoration(
                  color: controller.statusBg(idea.status),
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Text(
                  controller.statusLabel(idea.status),
                  style: fontStyles.font10LightGrey500.copyWith(
                    color: controller.statusText(idea.status),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                DateFormat("dd-MM-yyyy").format(idea.date),
                style: fontStyles.font12LightGrey500.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Text(idea.title, style: fontStyles.font14Black600),
          SizedBox(height: appSize.size8.h),
          Text(
            idea.description,
            style: fontStyles.font12LightGrey500.copyWith(
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          SizedBox(height: appSize.size12.h),
          Divider(
            height: 1,
            color: appColors.strokeColor.withValues(alpha: 0.7),
          ),
          SizedBox(height: appSize.size12.h),
          InkWell(
            onTap: () => controller.onViewDetails(idea),
            child: Row(
              children: [
                Text(
                  'View Details',
                  style: fontStyles.font14Brand700.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  width: appSize.size32.w,
                  height: appSize.size32.w,
                  decoration: BoxDecoration(
                    color: appColors.profileIconBlueBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: appColors.brandColor,
                    size: appSize.icon20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
