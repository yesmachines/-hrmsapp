import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/ideas/create_idea_screen/service/service.dart';

class CreateIdeaController extends GetxController with Bindings {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxList<XFile> attachedImages = <XFile>[].obs;

  static const int maxAttachments = 10;

  void onAttachmentsChanged(List<XFile> files) {
    attachedImages.assignAll(files);
  }

  void createIdea() {
    if (titleController.text.trim().isEmpty) {
      notificationHandler.sendNotification(
        message: "Fill idea title to continue",
        notificationType: .warning,
      );
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      notificationHandler.sendNotification(
        message: "Fill idea description to continue",
        notificationType: .warning,
      );
      return;
    }

    loadingScreen();
    CreateIdeasService.createIdea(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          ideaFiles: attachedImages.toList(),
        )
        .then((value) {
          Get.back();
          Get.back(result: true);
          notificationHandler.sendNotification(
            message: "Your idea has been saved",
            notificationType: .success,
          );
        })
        .onError((error, stackTrace) {
          Get.back();
          notificationHandler.apiErrorNotificationHandler(error: error);
        });
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(CreateIdeaController());
  }
}
