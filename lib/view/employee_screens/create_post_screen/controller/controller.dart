import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/utils/flutter_toast/flutter_toast.dart';

import '../../../../main.dart';

class CreatePostController extends GetxController implements Bindings {
  final TextEditingController captionController =
  TextEditingController();

  final Rxn<XFile> selectedImage = Rxn<XFile>();

  final ImagePicker _imagePicker = ImagePicker();

  final String userName = 'Aisha Rahman';

  final String profileImage = 'https://i.pravatar.cc/150?img=47';

  Future<void> pickImage() async {
    try {
      final XFile? image =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = image;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to select image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  Future<void> createPost() async {
    final caption =
    captionController.text.trim();

    if (caption.isEmpty &&
        selectedImage.value == null) {
      notificationHandler.sendNotification(
        message: "Please add a caption or photo",
        notificationType: NotificationType.warning,
      );

      return;
    }

    log(
      'Caption: $caption',
    );

    log(
      'Image: ${selectedImage.value?.path}',
    );
    Get.back(result: true);
    notificationHandler.sendNotification(
      message: "Post created successfully",
      notificationType: NotificationType.success,
    );

  }

  @override
  void onClose() {
    captionController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(CreatePostController());
  }
}