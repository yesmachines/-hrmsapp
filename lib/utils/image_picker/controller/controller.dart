import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/utils/image_picker/widget/source_sheet_widget/source_sheet_widget.dart';

import '../../../main.dart';
import '../../custom_bottom_sheet/custom_bottom_sheet.dart';

class ImagePickerController {
  static void removeAt({
    required int index,
    required List<XFile> images,
    required ValueChanged<List<XFile>> onChanged,
  }) {
    if (index < 0 || index >= images.length) return;
    final updated = [...images]..removeAt(index);
    onChanged(updated);
  }

  static Future<void> pickFromGallery({
    required List<XFile> images,
    required int maxAttachments,
    required int imageQuality,
    required ValueChanged<List<XFile>> onChanged,
  }) async {
    try {
      final remaining = maxAttachments - images.length;
      if (remaining <= 0) return;

      final picked = await ImagePicker().pickMultiImage(
        imageQuality: imageQuality,
        limit: remaining,
      );
      if (picked.isEmpty) return;

      List<XFile> updated = [...images, ...picked.take(remaining)];
      onChanged(updated);

      if (picked.length > remaining) {
        notificationHandler.sendNotification(
          message: "Only $maxAttachments images can be attached",
          notificationType: .warning,
        );
      }
    } catch (_) {
      notificationHandler.sendNotification(
        message: "Unable to pick images from gallery",
        notificationType: .error,
      );
    }
  }

  static Future<void> pickFromCamera({
    required List<XFile> images,
    required int maxAttachments,
    required int imageQuality,
    required ValueChanged<List<XFile>> onChanged,
  }) async {
    try {
      if (images.length >= maxAttachments) {
        notificationHandler.sendNotification(
          message: "You can attach up to $maxAttachments images",
          notificationType: .warning,
        );
        return;
      }

      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );
      if (image == null) return;
      onChanged([...images, image]);
    } catch (_) {
      notificationHandler.sendNotification(
        message: "Unable to capture image from camera",
        notificationType: .error,
      );
    }
  }

  static Future<void> showSourceSheet({
    required List<XFile> images,
    required int maxAttachments,
    required int imageQuality,
    required String sheetTitle,
    required String sheetSubTitle,
    required ValueChanged<List<XFile>> onChanged,
  }) async {
    if (images.length >= maxAttachments) {
      notificationHandler.sendNotification(
        message: "You can attach up to $maxAttachments images",
        notificationType: .warning,
      );
      return;
    }

    await customBottomSheet(
      title: sheetTitle,
      subTitle: sheetSubTitle,
      child: SourceSheetWidget(
        onGalleryTap: () {
          Get.back();
          pickFromGallery(
            images: images,
            maxAttachments: maxAttachments,
            imageQuality: imageQuality,
            onChanged: onChanged,
          );
        },
        onCameraTap: () {
          Get.back();
          pickFromCamera(
            images: images,
            maxAttachments: maxAttachments,
            imageQuality: imageQuality,
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}


// fontStyles.font14Brand500,

// Icon(
// Icons.add_photo_alternate_outlined,
// color: appColors.brandColor,
// size: 22.sp,
// ),
// SizedBox(width: appSize.size8.w),

// padding: EdgeInsets.symmetric(
// vertical: appSize.size16.h,
// horizontal: appSize.size12.w,
// ),