import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';

import '../../main.dart';

Future<dynamic> customBottomSheet({
  required Widget child,
  required String title,
  String? subTitle,
  bool isDismissible = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  Function()? onCloseTap,
}) {
  return Get.bottomSheet(
    Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        appSize.size16.w,
        appSize.size10.h,
        appSize.size16.w,
        appSize.size16.h,
      ),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(appSize.radius24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: appSize.size40.w,
                  height: appSize.size4.h,
                  decoration: BoxDecoration(
                    color: appColors.strokeColor,
                    borderRadius: BorderRadius.circular(appSize.radius60),
                  ),
                ),
              ),
              SizedBox(height: appSize.size16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: fontStyles.font20Black700Fixed),
                        if (subTitle != null) ...[
                          SizedBox(height: appSize.size6.h),
                          Text(subTitle, style: fontStyles.font14LightGrey400),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: appSize.size8.w),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: onCloseTap ?? Get.back,
                    borderRadius: BorderRadius.circular(appSize.radius60),
                    child: ImageHandler(
                      imageType: ImageType.svg,
                      imageUrl: iconData.closeRoundedSvg,
                      width: appSize.icon24,
                      height: appSize.icon24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: appSize.size16.h),
              child,
            ],
          ),
        ),
      ),
    ),
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: appColors.blackColor.withValues(alpha: 0.45),
  );
}
