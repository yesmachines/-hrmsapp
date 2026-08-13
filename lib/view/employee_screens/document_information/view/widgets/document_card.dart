import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/document_information/controller/controller.dart';

class DocumentCard extends GetView<DocumentInformationController> {
  const DocumentCard({super.key, required this.document});

  final DocumentItem document;

  @override
  Widget build(BuildContext context) {
    final hasStatus = document.status != DocumentStatus.none;

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
              Icon(
                Icons.description_outlined,
                color: appColors.brandColor,
                size: appSize.icon20,
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: Text(document.title, style: fontStyles.font14Black600),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Text(document.numberLabel, style: fontStyles.font10LightGrey500),
          SizedBox(height: appSize.size4.h),
          Text(document.numberValue, style: fontStyles.font14Black600),
          SizedBox(height: appSize.size12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expiry Date', style: fontStyles.font10LightGrey500),
                    SizedBox(height: appSize.size4.h),
                    Text(document.expiryDate, style: fontStyles.font14Black600),
                  ],
                ),
              ),
              if (hasStatus)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSize.size10.w,
                    vertical: appSize.size4.h,
                  ),
                  decoration: BoxDecoration(
                    color: controller.statusBg(document.status),
                    borderRadius: BorderRadius.circular(appSize.radius60),
                  ),
                  child: Text(
                    controller.statusLabel(document.status),
                    style: fontStyles.font10LightGrey500.copyWith(
                      color: controller.statusText(document.status),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
