import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';

import '../../controller/controller.dart';
import '../../service/model/hr_document.dart';

class HrDocumentCard extends GetView<HrDocumentsController> {
  const HrDocumentCard({super.key, required this.document});

  final HrDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Container(
                width: appSize.size44.w,
                height: appSize.size44.w,
                decoration: BoxDecoration(
                  color: document.iconBg,
                  borderRadius: BorderRadius.circular(appSize.radius12),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: document.iconColor,
                  size: appSize.icon20,
                ),
              ),
              SizedBox(width: appSize.size12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(document.title, style: fontStyles.font14Black600),
                    SizedBox(height: appSize.size6.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: appSize.size8.w,
                            vertical: appSize.size2.h,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.scaffoldGreyColor,
                            borderRadius: BorderRadius.circular(
                              appSize.radius60,
                            ),
                          ),
                          child: Text(
                            document.version,
                            style: fontStyles.font10LightGrey500.copyWith(
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        SizedBox(width: appSize.size8.w),
                        Flexible(
                          child: Text(
                            'Updated: ${document.updatedDate}',
                            style: fontStyles.font12LightGrey500.copyWith(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size14.h),
          CustomButton(
            buttonName: 'VIEW DOCUMENT',
            onPressed: () => controller.onViewDocument(document),
            buttonWidth: double.infinity,
            radius: appSize.radius12,
            prefixWidget: Padding(
              padding: EdgeInsets.only(right: appSize.size6.w),
              child: Icon(
                Icons.visibility_outlined,
                color: appColors.whiteColor,
                size: appSize.icon18,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: appSize.size12.h),
          ),
        ],
      ),
    );
  }
}
