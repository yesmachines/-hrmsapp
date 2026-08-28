import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/service/model/ticket_model.dart';

class RaiseTicketController extends GetxController with Bindings {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final categories = TicketCategory.values;
  final Rxn<TicketCategory> selectedCategory = Rxn();
  final Rxn<XFile> attachment = Rxn();

  static const int maxFileBytes = 5 * 1024 * 1024;

  void onCategoryTap() {
    customBottomSheet(
      title: 'Ticket Category',
      child: Column(
        children: categories.map((category) {
          final isSelected = category == selectedCategory.value;
          return InkWell(
            onTap: () {
              Get.back();
              selectedCategory.value = category;
            },
            borderRadius: BorderRadius.circular(appSize.radius12),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: appSize.size8),
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size14,
                vertical: appSize.size14,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? appColors.submittedBadgeBg
                    : appColors.scaffoldGreyColor,
                borderRadius: BorderRadius.circular(appSize.radius12),
                border: Border.all(
                  color: isSelected
                      ? appColors.brandColor.withValues(alpha: 0.35)
                      : appColors.strokeColor,
                ),
              ),
              child: Text(
                category.fullLabel,
                style: fontStyles.font14Black600.copyWith(
                  color: isSelected
                      ? appColors.brandColor
                      : appColors.blackColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> pickAttachment() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.length();
      if (bytes > maxFileBytes) {
        notificationHandler.sendNotification(
          message: 'File must be 5MB or smaller',
          notificationType: .warning,
        );
        return;
      }
      attachment.value = file;
    } catch (_) {
      notificationHandler.sendNotification(
        message: 'Unable to pick attachment',
        notificationType: .error,
      );
    }
  }

  void removeAttachment() => attachment.value = null;

  String? validate() {
    if (selectedCategory.value == null) return 'Select ticket category';
    if (subjectController.text.trim().isEmpty) return 'Enter issue title';
    if (descriptionController.text.trim().isEmpty) {
      return 'Describe your issue in detail';
    }
    if (descriptionController.text.trim().length < 10) {
      return 'Please provide a more detailed description';
    }
    return null;
  }

  void submitTicket() {
    final error = validate();
    if (error != null) {
      notificationHandler.sendNotification(
        message: error,
        notificationType: .warning,
      );
      return;
    }

    final now = DateTime.now();
    final ticket = TicketModel(
      id: now.millisecondsSinceEpoch.toString(),
      ticketNumber: 'TK-${now.millisecondsSinceEpoch.toString().substring(7)}',
      category: selectedCategory.value!,
      status: TicketStatus.newTicket,
      subject: subjectController.text.trim(),
      description: descriptionController.text.trim(),
      date: now,
      submittedDate: now,
      attachments: attachment.value == null
          ? const []
          : [
              TicketAttachment(
                name: attachment.value!.name,
                type: TicketAttachmentType.image,
                size: 'Image',
              ),
            ],
    );

    loadingScreen();
    Future.delayed(const Duration(milliseconds: 700), () {
      Get.back();
      Get.back(result: ticket);
      notificationHandler.sendNotification(
        message: 'Ticket submitted',
        notificationType: .success,
      );
    });
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(RaiseTicketController());
  }
}
