import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/letter_requests/controller/controller.dart';

class LetterRequestCard extends GetView<LetterRequestsController> {
  const LetterRequestCard({super.key, required this.request});

  final LetterRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size14.w),
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
                width: appSize.size40.w,
                height: appSize.size40.w,
                decoration: BoxDecoration(
                  color: appColors.profileIconBlueBg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: appColors.brandColor,
                  size: appSize.icon20,
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: Text(request.title, style: fontStyles.font14Black600),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size10.w,
                  vertical: appSize.size4.h,
                ),
                decoration: BoxDecoration(
                  color: appColors.activeBadgeBg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Text(
                  request.status,
                  style: fontStyles.font10LightGrey500.copyWith(
                    color: appColors.activeBadgeText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Text(
            'Apply Date: ${request.applyDate}',
            style: fontStyles.font12LightGrey500.copyWith(
              letterSpacing: 0,
              color: appColors.mediumGreyColor,
            ),
          ),
          SizedBox(height: appSize.size4.h),
          Text(
            'Approved Date: ${request.approvedDate}',
            style: fontStyles.font12LightGrey500.copyWith(
              letterSpacing: 0,
              color: appColors.mediumGreyColor,
            ),
          ),
          SizedBox(height: appSize.size12.h),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => controller.onViewRequest(request),
              borderRadius: BorderRadius.circular(appSize.radius8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size12.w,
                  vertical: appSize.size8.h,
                ),
                decoration: BoxDecoration(
                  color: appColors.whiteColor,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                  border: Border.all(color: appColors.brandColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: appSize.icon16,
                      color: appColors.brandColor,
                    ),
                    SizedBox(width: appSize.size4.w),
                    Text(
                      'View',
                      style: fontStyles.font12Brand600.copyWith(
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
