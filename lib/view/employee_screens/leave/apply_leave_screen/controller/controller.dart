import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/leave_apply_validation.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/service.dart';

class ApplyLeaveController extends GetxController with Bindings {
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController handoverPersonController =
      TextEditingController();
  final TextEditingController handoverDescriptionController =
      TextEditingController();
  final TextEditingController personalContactController =
      TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController travelContactController = TextEditingController();
  final TextEditingController childAgeController = TextEditingController();

  Rxn<LeaveMetaModel> leaveMetaData = Rxn(null);
  RxBool leaveMetaDataHasError = RxBool(false);

  final Rxn<LeaveTypeModel> selectedLeaveType = Rxn(null);
  final Rxn<DateTime> startDate = Rxn(DateTime.now());
  final Rxn<DateTime> endDate = Rxn(DateTime.now());
  final RxList<XFile> certificates = RxList([]);
  final RxList<XFile> doctorLetter = RxList([]);

  final RxBool isTravellingOutside = false.obs;
  final RxBool declarationSigned = false.obs;
  final RxnString selectedRelative = RxnString();
  final Rxn<DateTime> dueDate = Rxn();

  /// Flags that should come from API/employee profile later.
  final RxBool alreadyTakenFestivalThisYear = false.obs;
  final RxBool alreadyTakenPilgrimage = false.obs;
  final RxBool nationalityMatched = true.obs;
  final RxBool religionMatched = true.obs;

  static const Map<String, int> compassionateRelativeLimits = {
    'Spouse': 5,
    'Child': 5,
    'Parent': 5,
    'Sibling': 3,
    'Grandparent': 3,
    'Other Relative': 3,
  };

  LeaveApplyKind get selectedKind =>
      leaveApplyKindFromName(selectedLeaveType.value?.leaveName);

  String get uploadTitle {
    switch (selectedKind) {
      case LeaveApplyKind.sick:
        return 'Upload Medical Certificate';
      case LeaveApplyKind.maternity:
        return "Upload Doctor's Letter";
      default:
        return 'Upload Supporting Document';
    }
  }

  bool get showUploadBox {
    switch (selectedKind) {
      case LeaveApplyKind.sick:
      case LeaveApplyKind.maternity:
      case LeaveApplyKind.other:
        return true;
      default:
        return selectedLeaveType.value?.requiresAttachment == true;
    }
  }

  bool get sickNeedsCertificate {
    if (selectedKind != LeaveApplyKind.sick) return false;
    final start = startDate.value;
    final end = endDate.value;
    if (start == null || end == null) return false;
    return leaveAppliedDays > 2 || leaveRangeIncludesWeekend(start, end);
  }

  String get sickPayTierLabel {
    final used = selectedLeaveType.value?.balance.used ?? 0;
    return sickLeavePayTier(appliedDays: leaveAppliedDays, usedSickDays: used);
  }

  int get leaveAppliedDays {
    final start = startDate.value;
    final end = endDate.value;
    if (start == null || end == null) return 0;
    if (end.isBefore(start)) return 0;
    return end.difference(start).inDays + 1;
  }

  int get remainingBalance => selectedLeaveType.value?.balance.balance ?? 0;

  int? get selectedRelativeDayLimit {
    final relative = selectedRelative.value;
    if (relative == null) return null;
    return compassionateRelativeLimits[relative];
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void onLeaveTypeChanged(LeaveTypeModel type) {
    selectedLeaveType.value = type;
    certificates.clear();
    doctorLetter.clear();
    isTravellingOutside.value = false;
    declarationSigned.value = false;
    selectedRelative.value = null;
    dueDate.value = null;
    destinationController.clear();
    travelContactController.clear();
    childAgeController.clear();
  }

  void onLeaveTypeTap() {
    final types = leaveMetaData.value?.leaveTypes ?? [];
    customBottomSheet(
      title: 'Leave Type',
      child: Column(
        children: types.map((type) {
          final kind = leaveApplyKindFromName(type.leaveName);
          final disabled = _isLeaveTypeDisabled(kind);
          final selected = type.id == selectedLeaveType.value?.id;
          return InkWell(
            onTap: disabled
                ? null
                : () {
                    onLeaveTypeChanged(type);
                    Get.back();
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
                color: disabled
                    ? appColors.strokeColor.withValues(alpha: 0.35)
                    : selected
                        ? appColors.submittedBadgeBg
                        : appColors.scaffoldGreyColor,
                borderRadius: BorderRadius.circular(appSize.radius12),
                border: Border.all(
                  color: selected
                      ? appColors.brandColor.withValues(alpha: 0.35)
                      : appColors.strokeColor,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: disabled
                          ? appColors.lightGreyColor
                          : appColors.brandColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: appSize.size10),
                  Expanded(
                    child: Text(
                      type.leaveName,
                      style: fontStyles.font14Black600.copyWith(
                        color: disabled
                            ? appColors.lightGreyColor
                            : selected
                                ? appColors.brandColor
                                : appColors.blackColor,
                      ),
                    ),
                  ),
                  if (disabled)
                    Text(
                      'Unavailable',
                      style: fontStyles.font10LightGrey500,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isLeaveTypeDisabled(LeaveApplyKind kind) {
    if (kind == LeaveApplyKind.festival &&
        alreadyTakenFestivalThisYear.value) {
      return true;
    }
    if (kind == LeaveApplyKind.pilgrimage && alreadyTakenPilgrimage.value) {
      return true;
    }
    return false;
  }

  void onRelativeTap() {
    customBottomSheet(
      title: 'Select Relative',
      child: Column(
        children: compassionateRelativeLimits.entries.map((entry) {
          final selected = entry.key == selectedRelative.value;
          return InkWell(
            onTap: () {
              selectedRelative.value = entry.key;
              Get.back();
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
                color: selected
                    ? appColors.submittedBadgeBg
                    : appColors.scaffoldGreyColor,
                borderRadius: BorderRadius.circular(appSize.radius12),
                border: Border.all(
                  color: selected
                      ? appColors.brandColor.withValues(alpha: 0.35)
                      : appColors.strokeColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: fontStyles.font14Black600.copyWith(
                        color: selected
                            ? appColors.brandColor
                            : appColors.blackColor,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value} days max',
                    style: fontStyles.font12LightGrey500,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> pickStartDate() async {
    final picked = await _pickDate(
      initial: startDate.value ?? DateTime.now(),
      lastDate: endDate.value,
    );
    if (picked == null) return;
    startDate.value = picked;
    final end = endDate.value;
    if (end != null && end.isBefore(picked)) {
      endDate.value = picked;
    }
  }

  Future<void> pickEndDate() async {
    final picked = await _pickDate(
      initial: endDate.value ?? startDate.value ?? DateTime.now(),
      firstDate: startDate.value,
    );
    if (picked == null) return;
    endDate.value = picked;
  }

  Future<void> pickDueDate() async {
    final picked = await _pickDate(
      initial: dueDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
    );
    if (picked == null) return;
    dueDate.value = picked;
  }

  Future<DateTime?> _pickDate({
    required DateTime initial,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: Get.context!,
      initialDate: initial,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
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
  }

  Future<void> pickCertificate() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) return;
      if (selectedKind == LeaveApplyKind.maternity) {
        doctorLetter.assignAll([file]);
      } else {
        certificates.assignAll([file]);
      }
    } catch (_) {
      notificationHandler.sendNotification(
        message: 'Unable to pick certificate',
        notificationType: .error,
      );
    }
  }

  void removeCertificate() {
    if (selectedKind == LeaveApplyKind.maternity) {
      doctorLetter.clear();
    } else {
      certificates.clear();
    }
  }

  Future<LeaveMetaModel> getLeaveMetaData() async {
    leaveMetaDataHasError.value = false;
    return ApplyLeaveService.getLeaveMeta()
        .then((value) {
          leaveMetaData.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          leaveMetaDataHasError.value = true;
          throw Exception(error);
        });
  }

  LeaveApplyValidationResult validateForm() {
    final start = startDate.value;
    final end = endDate.value;
    final includesWeekend =
        start != null && end != null && leaveRangeIncludesWeekend(start, end);

    final ageText = childAgeController.text.trim();
    final childAge = ageText.isEmpty ? null : int.tryParse(ageText);

    return validateLeaveApply(
      LeaveApplyValidationInput(
        leaveTypeName: selectedLeaveType.value?.leaveName,
        startDate: start,
        endDate: end,
        remarks: remarksController.text,
        remainingBalance: remainingBalance,
        appliedDays: leaveAppliedDays,
        includesWeekend: includesWeekend,
        certificates: certificates.toList(),
        handoverPerson: handoverPersonController.text,
        handoverDescription: handoverDescriptionController.text,
        personalContact: personalContactController.text,
        emergencyContact: emergencyContactController.text,
        isTravellingOutside: isTravellingOutside.value,
        destination: destinationController.text,
        travelContact: travelContactController.text,
        declarationSigned: declarationSigned.value,
        relative: selectedRelative.value,
        relativeDayLimit: selectedRelativeDayLimit,
        alreadyTakenFestivalThisYear: alreadyTakenFestivalThisYear.value,
        nationalityMatched: nationalityMatched.value,
        religionMatched: religionMatched.value,
        dueDate: dueDate.value,
        doctorLetter: doctorLetter.toList(),
        childAgeMonths: childAge,
        alreadyTakenPilgrimage: alreadyTakenPilgrimage.value,
      ),
    );
  }

  void submitLeave() {
    final result = validateForm();
    if (!result.isValid) {
      notificationHandler.sendNotification(
        message: result.message ?? 'Please complete required fields',
        notificationType: .warning,
      );
      return;
    }

    loadingScreen();
    Future.delayed(const Duration(milliseconds: 700), () {
      Get.back();
      Get.back(result: true);
      notificationHandler.sendNotification(
        message: 'Leave request submitted',
        notificationType: .success,
      );
    });
  }

  @override
  void onClose() {
    remarksController.dispose();
    handoverPersonController.dispose();
    handoverDescriptionController.dispose();
    personalContactController.dispose();
    emergencyContactController.dispose();
    destinationController.dispose();
    travelContactController.dispose();
    childAgeController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(ApplyLeaveController());
  }
}
