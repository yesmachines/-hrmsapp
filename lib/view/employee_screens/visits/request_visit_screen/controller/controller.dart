import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class RequestVisitController extends GetxController with Bindings {
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  final visitTypes = VisitType.values.map((e) => e.label).toList();
  final approvers = const [
    'Mohammed Hassan, HR Director',
    'Priya Nair, HR Manager',
    'Ahmed Hassan, Team Lead',
  ];

  final availableEmployees = const [
    VisitAssignee(id: 'a1', name: 'Ahmed A.', role: 'Engineer', initials: 'AA'),
    VisitAssignee(id: 'a2', name: 'Sara K.', role: 'PM', initials: 'SK'),
    VisitAssignee(id: 'a3', name: 'Priya N.', role: 'HR', initials: 'PN'),
    VisitAssignee(id: 'a4', name: 'Mohammed A.', role: 'Dev', initials: 'MA'),
  ];

  final RxnString selectedVisitType = RxnString();
  final Rxn<DateTime> visitDate = Rxn();
  final Rxn<TimeOfDay> expectedTime = Rxn();
  final RxList<VisitAssignee> assignedEmployees = <VisitAssignee>[].obs;
  final RxnString selectedApprover = RxnString();
  final RxList<XFile> attachments = <XFile>[].obs;

  String get visitDateLabel {
    final date = visitDate.value;
    if (date == null) return 'Select date';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String get expectedTimeLabel {
    final time = expectedTime.value;
    if (time == null) return 'Select time';
    final dt = DateTime(2026, 1, 1, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  void onVisitTypeTap() {
    _openOptions(
      title: 'Visit Type',
      options: visitTypes,
      selected: selectedVisitType.value,
      onSelected: (value) => selectedVisitType.value = value,
    );
  }

  void onApproverTap() {
    _openOptions(
      title: 'Required Approval',
      options: approvers,
      selected: selectedApprover.value,
      onSelected: (value) => selectedApprover.value = value,
    );
  }

  void _openOptions({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    customBottomSheet(
      title: title,
      child: Column(
        children: options.map((option) {
          final isSelected = option == selected;
          return InkWell(
            onTap: () {
              Get.back();
              onSelected(option);
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
                option,
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

  Future<void> pickVisitDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: visitDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.brandColor,
              onPrimary: appColors.whiteColor,
              surface: appColors.whiteColor,
              onSurface: appColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) visitDate.value = picked;
  }

  Future<void> pickExpectedTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: expectedTime.value ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.brandColor,
              onPrimary: appColors.whiteColor,
              surface: appColors.whiteColor,
              onSurface: appColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) expectedTime.value = picked;
  }

  void onAssignEmployeesTap() {
    final temp = assignedEmployees.toList().obs;
    customBottomSheet(
      title: 'Assigned Employees',
      child: Column(
        children: [
          ...availableEmployees.map((employee) {
            return Obx(() {
              final selected = temp.any((e) => e.id == employee.id);
              return CheckboxListTile(
                value: selected,
                activeColor: appColors.brandColor,
                contentPadding: EdgeInsets.zero,
                title: Text(employee.name, style: fontStyles.font14Black600),
                subtitle: Text(
                  employee.role,
                  style: fontStyles.font12LightGrey500,
                ),
                onChanged: (value) {
                  if (value == true) {
                    temp.add(employee);
                  } else {
                    temp.removeWhere((e) => e.id == employee.id);
                  }
                },
              );
            });
          }),
          SizedBox(height: appSize.size12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                assignedEmployees.assignAll(temp);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.brandColor,
                foregroundColor: appColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(appSize.radius12),
                ),
              ),
              child: Text('Done', style: fontStyles.font14White600),
            ),
          ),
        ],
      ),
    );
  }

  void removeEmployee(VisitAssignee employee) {
    assignedEmployees.removeWhere((e) => e.id == employee.id);
  }

  Future<void> pickAttachments() async {
    try {
      final files = await ImagePicker().pickMultiImage(imageQuality: 85);
      if (files.isEmpty) return;
      attachments.addAll(files);
    } catch (_) {
      notificationHandler.sendNotification(
        message: 'Unable to pick attachments',
        notificationType: .error,
      );
    }
  }

  void removeAttachment(int index) {
    if (index < 0 || index >= attachments.length) return;
    attachments.removeAt(index);
  }

  void submitVisit() {
    if (selectedVisitType.value == null) {
      notificationHandler.sendNotification(
        message: 'Select visit type to continue',
        notificationType: .warning,
      );
      return;
    }
    if (purposeController.text.trim().isEmpty) {
      notificationHandler.sendNotification(
        message: 'Enter purpose of visit',
        notificationType: .warning,
      );
      return;
    }
    if (locationController.text.trim().isEmpty) {
      notificationHandler.sendNotification(
        message: 'Enter visit location',
        notificationType: .warning,
      );
      return;
    }
    if (visitDate.value == null || expectedTime.value == null) {
      notificationHandler.sendNotification(
        message: 'Select visit date and time',
        notificationType: .warning,
      );
      return;
    }

    loadingScreen();
    Future.delayed(const Duration(milliseconds: 700), () {
      Get.back();
      Get.back(result: true);
      notificationHandler.sendNotification(
        message: 'Visit request submitted',
        notificationType: .success,
      );
    });
  }

  @override
  void onClose() {
    purposeController.dispose();
    locationController.dispose();
    remarksController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(RequestVisitController());
  }
}
