import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/image_picker/controller/controller.dart';

import '../../main.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker({
    super.key,
    required this.images,
    required this.onChanged,
    this.maxAttachments = 10,
    this.title = "Attachments",
    this.attachLabel = "Attach images",
    this.sheetTitle = "Attach Image",
    this.sheetSubTitle = "Choose an option to add images",
    this.imageQuality = 85,
    this.showTitle = true,
  });

  final List<XFile> images;
  final ValueChanged<List<XFile>> onChanged;
  final int maxAttachments;
  final String title;
  final String attachLabel;
  final String sheetTitle;
  final String sheetSubTitle;
  final int imageQuality;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(title, style: fontStyles.font14Black600),
          SizedBox(height: appSize.size12.h),
        ],
        if (images.isNotEmpty) ...[
          SizedBox(
            height: 104.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                top: appSize.size6.h,
                right: appSize.size6.w,
              ),
              itemCount: images.length,
              separatorBuilder: (_, _) => SizedBox(width: appSize.size10.w),
              itemBuilder: (context, index) {
                final file = images[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(appSize.radius12),
                      child: Image.file(
                        File(file.path),
                        width: 96.w,
                        height: 96.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -4.h,
                      right: -4.w,
                      child: GestureDetector(
                        onTap: () => ImagePickerController.removeAt(
                          index: index,
                          images: images,
                          onChanged: onChanged,
                        ),
                        child: Container(
                          width: appSize.size20.w,
                          height: appSize.size20.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: appColors.errorColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: appColors.whiteColor,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 12.sp,
                            color: appColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: appSize.size12.h),
        ],
        CustomButton(
          buttonWidth: double.infinity,
          padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
          prefixWidget: Padding(
            padding: EdgeInsets.only(right: appSize.size8.w),
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: appColors.brandColor,
              size: 22.sp,
            ),
          ),
          borderColor: appColors.brandColor,
          buttonColor: Colors.transparent,
          buttonName: images.isEmpty
              ? attachLabel
              : "Add more images (${images.length}/$maxAttachments)",
          fontStyle: fontStyles.font14Brand500,
          onPressed: () => ImagePickerController.showSourceSheet(
            images: images,
            maxAttachments: maxAttachments,
            imageQuality: imageQuality,
            sheetTitle: sheetTitle,
            sheetSubTitle: sheetSubTitle,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
