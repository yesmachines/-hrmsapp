import 'dart:async';

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
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/handover_person_sheet.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_view_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_status_enum.dart';

class ApplyLeaveController extends GetxController with Bindings {
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController handoverPersonController =
      TextEditingController();
  final TextEditingController handoverSearchController =
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
  final Rxn<LeaveModel> editingLeave = Rxn(null);
  final RxBool editNotAllowed = false.obs;
  String? editingLeaveId;

  bool get isEditMode => editingLeaveId != null && editingLeaveId!.isNotEmpty;

  final Rxn<LeaveTypeModel> selectedLeaveType = Rxn(null);
  final Rxn<DateTime> startDate = Rxn(DateTime.now());
  final Rxn<DateTime> endDate = Rxn(DateTime.now());
  final RxList<XFile> certificates = RxList([]);
  final RxList<XFile> doctorLetter = RxList([]);

  final RxBool isTravellingOutside = false.obs;
  final RxBool declarationSigned = false.obs;
  final RxnString selectedRelative = RxnString();
  final Rxn<DateTime> dueDate = Rxn();
  final Rxn<DateTime> childBirthDate = Rxn();
  final Rxn<EmployeeModel> selectedHandoverPerson = Rxn(null);
  final Rxn<FestivalModel> selectedFestival = Rxn(null);
  final RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  final RxBool employeesLoading = false.obs;
  final RxBool employeesHasError = false.obs;
  final RxString employeeSearchQuery = ''.obs;
  Timer? _employeeSearchDebounce;

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

  LeaveApplyKind get selectedKind => leaveApplyKindFromType(
    code: selectedLeaveType.value?.leaveCode,
    name: selectedLeaveType.value?.leaveName,
  );

  bool get needsHandover =>
      selectedKind == LeaveApplyKind.annual ||
      selectedLeaveType.value?.requiresHandover == true;

  List<EmployeeModel> get filteredHandoverEmployees {
    final currentId = leaveMetaData.value?.employee.id;
    final query = employeeSearchQuery.value.trim().toLowerCase();
    return employees.where((employee) {
      if (employee.id == currentId) return false;
      if (query.isEmpty) return true;
      return employee.name.toLowerCase().contains(query) ||
          employee.designation.toLowerCase().contains(query);
    }).toList();
  }

  List<FestivalModel> get availableFestivals {
    final fromType = selectedLeaveType.value?.festivals ?? [];
    if (fromType.isNotEmpty) return fromType;
    return leaveMetaData.value?.festivals ?? [];
  }

  String? get handoverPersonId {
    final selectedId = selectedHandoverPerson.value?.id;
    if (selectedId != null && selectedId.isNotEmpty) return selectedId;
    return null;
  }

  XFile? get selectedCertificate {
    if (selectedKind == LeaveApplyKind.maternity) {
      return doctorLetter.isEmpty ? null : doctorLetter.first;
    }
    return certificates.isEmpty ? null : certificates.first;
  }

  LeavePolicyModel? get selectedPolicy => selectedLeaveType.value?.policy;

  String get uploadTitle {
    switch (selectedKind) {
      case LeaveApplyKind.sick:
        return needsSupportingDocument
            ? 'Upload Medical Certificate *'
            : 'Upload Medical Certificate';
      case LeaveApplyKind.maternity:
        return "Upload Doctor's Letter *";
      default:
        return needsSupportingDocument
            ? 'Upload Supporting Document *'
            : 'Upload Supporting Document';
    }
  }

  bool get showUploadBox {
    switch (selectedKind) {
      case LeaveApplyKind.sick:
      case LeaveApplyKind.maternity:
      case LeaveApplyKind.other:
        return true;
      default:
        return selectedLeaveType.value?.requiresAttachment == true ||
            selectedPolicy?.requiresAttachment == true ||
            selectedPolicy?.requiresWeekendDocument == true ||
            selectedPolicy?.requiresDocumentAfterDays != null;
    }
  }

  bool get sickNeedsCertificate {
    if (selectedKind != LeaveApplyKind.sick) return false;
    return needsSupportingDocument;
  }

  bool get needsSupportingDocument {
    final policy = selectedPolicy;
    if (policy?.requiresAttachment == true) return true;

    final start = startDate.value;
    final end = endDate.value;
    final includesWeekend =
        start != null && end != null && leaveRangeIncludesWeekend(start, end);

    if (policy?.requiresWeekendDocument == true && includesWeekend) {
      return true;
    }
    final afterDays = policy?.requiresDocumentAfterDays;
    if (afterDays != null && leaveAppliedDays > afterDays) {
      return true;
    }
    if (selectedKind == LeaveApplyKind.sick && policy == null) {
      if (start == null || end == null) return false;
      return leaveAppliedDays > 2 || includesWeekend;
    }
    return false;
  }

  String get sickPayTierLabel {
    final used = selectedLeaveType.value?.balance.used ?? 0;
    final policy = selectedPolicy;
    return sickLeavePayTier(
      appliedDays: leaveAppliedDays,
      usedSickDays: used,
      fullPayDays: policy?.fullPayDays,
      halfPayDays: policy?.halfPayDays,
    );
  }

  int get leaveAppliedDays {
    final start = startDate.value;
    final end = endDate.value;
    if (start == null || end == null) return 0;
    if (end.isBefore(start)) return 0;
    return end.difference(start).inDays + 1;
  }

  int get remainingBalance {
    final base = selectedLeaveType.value?.balance.balance ?? 0;
    final original = editingLeave.value;
    if (!isEditMode || original == null) return base;
    if (original.type.id == selectedLeaveType.value?.id) {
      return base + original.durationDays;
    }
    return base;
  }

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
    childBirthDate.value = null;
    selectedHandoverPerson.value = null;
    selectedFestival.value = null;
    handoverPersonController.clear();
    handoverDescriptionController.clear();
    personalContactController.clear();
    emergencyContactController.clear();
    destinationController.clear();
    travelContactController.clear();
    childAgeController.clear();
    if (needsHandover) {
      fetchEmployees();
    }
  }

  void onLeaveTypeTap() {
    final types = leaveMetaData.value?.leaveTypes ?? [];
    customBottomSheet(
      title: 'Leave Type',
      child: Column(
        children: types.map((type) {
          final kind = leaveApplyKindFromType(
            code: type.leaveCode,
            name: type.leaveName,
          );
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
                    Text('Unavailable', style: fontStyles.font10LightGrey500),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isLeaveTypeDisabled(LeaveApplyKind kind) {
    if (kind == LeaveApplyKind.festival && alreadyTakenFestivalThisYear.value) {
      return true;
    }
    if (kind == LeaveApplyKind.pilgrimage && alreadyTakenPilgrimage.value) {
      return true;
    }
    return false;
  }

  void onHandoverPersonTap() {
    handoverSearchController.clear();
    employeeSearchQuery.value = '';
    fetchEmployees();
    customBottomSheet(
      title: 'Handover Person',
      child: const HandoverPersonSheet(),
    );
  }

  void onHandoverSearchChanged(String value) {
    employeeSearchQuery.value = value;
    _employeeSearchDebounce?.cancel();
    _employeeSearchDebounce = Timer(const Duration(milliseconds: 400), () {
      fetchEmployees(search: value);
    });
  }

  void onHandoverPersonSelected(EmployeeModel employee) {
    selectedHandoverPerson.value = employee;
    handoverPersonController.text = employee.name;
    Get.back();
  }

  Future<void> fetchEmployees({String? search}) async {
    employeesLoading.value = true;
    employeesHasError.value = false;
    try {
      final result = await ApplyLeaveService.getEmployees(search: search);
      employees.assignAll(result);
    } catch (_) {
      employeesHasError.value = true;
      if (employees.isEmpty) {
        notificationHandler.sendNotification(
          message: 'Unable to load employees',
          notificationType: .error,
        );
      }
    } finally {
      employeesLoading.value = false;
    }
  }

  void onFestivalTap() {
    final festivals = availableFestivals;
    if (festivals.isEmpty) return;
    customBottomSheet(
      title: 'Festival',
      child: Column(
        children: festivals.map((festival) {
          final selected = festival.id == selectedFestival.value?.id;
          return InkWell(
            onTap: () {
              selectedFestival.value = festival;
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
              child: Text(
                festival.name,
                style: fontStyles.font14Black600.copyWith(
                  color: selected ? appColors.brandColor : appColors.blackColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
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

  Future<void> pickChildBirthDate() async {
    final now = DateTime.now();
    final picked = await _pickDate(
      initial: childBirthDate.value ?? now,
      firstDate: DateTime(now.year, now.month - 6, now.day),
      lastDate: now,
    );
    if (picked == null) return;
    childBirthDate.value = picked;
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

  @override
  void onInit() {
    editingLeaveId = _leaveIdFromArguments(Get.arguments);
    super.onInit();
  }

  String? _leaveIdFromArguments(dynamic args) {
    if (args is String && args.trim().isNotEmpty) return args.trim();
    if (args is Map) {
      final id = args['leaveId'] ?? args['id'];
      if (id != null && id.toString().trim().isNotEmpty) {
        return id.toString().trim();
      }
    }
    return null;
  }

  Future<LeaveMetaModel> getLeaveMetaData() async {
    leaveMetaDataHasError.value = false;
    return ApplyLeaveService.getLeaveMeta()
        .then((value) async {
          leaveMetaData.value = value;
          if (isEditMode) {
            try {
              await loadEditingLeave(editingLeaveId!);
            } catch (error) {
              leaveMetaDataHasError.value = true;
              leaveMetaData.value = null;
              throw Exception(error);
            }
          }
          return value;
        })
        .onError((error, stackTrace) {
          leaveMetaDataHasError.value = true;
          throw Exception(error);
        });
  }

  Future<void> loadEditingLeave(String id) async {
    editNotAllowed.value = false;
    final leave = await LeaveViewService.getLeave(id: id);
    if (leave.status != LeaveStatus.requested) {
      editNotAllowed.value = true;
      notificationHandler.sendNotification(
        message: 'Only requested leaves can be edited',
        notificationType: .warning,
      );
      return;
    }
    populateFromLeave(leave);
  }

  void populateFromLeave(LeaveModel leave) {
    editingLeave.value = leave;
    final types = leaveMetaData.value?.leaveTypes ?? [];
    LeaveTypeModel? matchedType;
    final byId = types.where((type) => type.id == leave.type.id);
    if (byId.isNotEmpty) {
      matchedType = byId.first;
    } else {
      final leaveName = leave.type.leaveType.toLowerCase();
      final byName = types.where(
        (type) => type.leaveName.toLowerCase() == leaveName,
      );
      if (byName.isNotEmpty) matchedType = byName.first;
    }
    selectedLeaveType.value = matchedType;
    startDate.value = leave.fromDate;
    endDate.value = leave.toDate;
    remarksController.text = leave.remarks;
    handoverDescriptionController.text = leave.handoverDescription;
    personalContactController.text = leave.personalContact;
    emergencyContactController.text = leave.emergencyContact;
    destinationController.text = leave.destination;
    travelContactController.text = leave.travelContact;
    childAgeController.text = leave.childAge;
    isTravellingOutside.value = leave.travelingOutsideCountry ?? false;
    declarationSigned.value = leave.declarationSigned ?? false;
    selectedRelative.value = leave.relative.isEmpty ? null : leave.relative;
    dueDate.value = leave.dueDate;
    childBirthDate.value = leave.childBirthDate;

    if (leave.handoverPersonId.isNotEmpty ||
        leave.handoverPersonName.isNotEmpty) {
      selectedHandoverPerson.value = EmployeeModel(
        id: leave.handoverPersonId,
        name: leave.handoverPersonName,
        imageUrl: '',
      );
      handoverPersonController.text = leave.handoverPersonName;
    }

    if (leave.festivalId.isNotEmpty || leave.festivalName.isNotEmpty) {
      final festivals = availableFestivals;
      FestivalModel? festival;
      if (leave.festivalId.isNotEmpty) {
        final byFestivalId = festivals.where((item) => item.id == leave.festivalId);
        if (byFestivalId.isNotEmpty) festival = byFestivalId.first;
      }
      if (festival == null && leave.festivalName.isNotEmpty) {
        final byFestivalName = festivals.where(
          (item) => item.name.toLowerCase() == leave.festivalName.toLowerCase(),
        );
        if (byFestivalName.isNotEmpty) festival = byFestivalName.first;
      }
      selectedFestival.value =
          festival ??
          FestivalModel(id: leave.festivalId, name: leave.festivalName);
    }

    if (needsHandover) {
      fetchEmployees();
    }
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
        leaveTypeCode: selectedLeaveType.value?.leaveCode,
        leaveTypeName: selectedLeaveType.value?.leaveName,
        startDate: start,
        endDate: end,
        remarks: remarksController.text,
        remainingBalance: remainingBalance,
        appliedDays: leaveAppliedDays,
        includesWeekend: includesWeekend,
        certificates: certificates.toList(),
        handoverPersonId: handoverPersonId,
        handoverPerson: handoverPersonController.text,
        handoverDescription: handoverDescriptionController.text,
        personalContact: personalContactController.text,
        emergencyContact: emergencyContactController.text,
        requiresHandover: needsHandover,
        isTravellingOutside: isTravellingOutside.value,
        destination: destinationController.text,
        travelContact: travelContactController.text,
        declarationSigned: declarationSigned.value,
        relative: selectedRelative.value,
        relativeDayLimit: selectedRelativeDayLimit,
        alreadyTakenFestivalThisYear: isEditMode &&
                selectedKind == LeaveApplyKind.festival
            ? false
            : alreadyTakenFestivalThisYear.value,
        nationalityMatched: nationalityMatched.value,
        religionMatched: religionMatched.value,
        dueDate: dueDate.value,
        doctorLetter: doctorLetter.toList(),
        childBirthDate: childBirthDate.value,
        childAgeMonths: childAge,
        festivalId: selectedFestival.value?.id,
        alreadyTakenPilgrimage: isEditMode &&
                selectedKind == LeaveApplyKind.pilgrimage
            ? false
            : alreadyTakenPilgrimage.value,
        hasExistingAttachment: isEditMode &&
            (editingLeave.value?.attachments.isNotEmpty ?? false),
        policyRequiresAttachment: selectedPolicy?.requiresAttachment == true,
        requiresWeekendDocument:
            selectedPolicy?.requiresWeekendDocument == true,
        requiresDocumentAfterDays: selectedPolicy?.requiresDocumentAfterDays,
      ),
    );
  }

  Map<String, dynamic> buildApplyLeaveData() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final type = selectedLeaveType.value;
    final start = startDate.value;
    final end = endDate.value;
    final data = <String, dynamic>{};

    if (type != null) {
      data['leave_type_id'] = type.id;
    }
    if (start != null) {
      data['start_date'] = dateFormat.format(start);
    }
    if (end != null) {
      data['end_date'] = dateFormat.format(end);
    }
    if (leaveAppliedDays > 0) {
      data['total_days'] = leaveAppliedDays;
    }

    final remarks = remarksController.text.trim();
    if (remarks.isNotEmpty) {
      data['remarks'] = remarks;
    }

    if (needsHandover) {
      final personId = handoverPersonId;
      if (personId != null) {
        data['handover_person_id'] = personId;
      }
      final handoverDescription = handoverDescriptionController.text.trim();
      if (handoverDescription.isNotEmpty) {
        data['handover_description'] = handoverDescription;
      }
      final personalContact = personalContactController.text.trim();
      if (personalContact.isNotEmpty) {
        data['personal_contact_no'] = personalContact;
      }
      final emergencyContact = emergencyContactController.text.trim();
      if (emergencyContact.isNotEmpty) {
        data['emergency_contact_no'] = emergencyContact;
      }
      data['traveling_outside_country'] = isTravellingOutside.value ? 1 : 0;
      if (isTravellingOutside.value) {
        final destination = destinationController.text.trim();
        if (destination.isNotEmpty) {
          data['destination'] = destination;
        }
        final travelContact = travelContactController.text.trim();
        if (travelContact.isNotEmpty) {
          data['travel_contact_no'] = travelContact;
        }
      } else {
        data['declaration_signed'] = declarationSigned.value ? 1 : 0;
      }
    }

    if (selectedKind == LeaveApplyKind.maternity && dueDate.value != null) {
      data['due_date'] = dateFormat.format(dueDate.value!);
    }

    if (selectedKind == LeaveApplyKind.parental &&
        childBirthDate.value != null) {
      data['child_birth_date'] = dateFormat.format(childBirthDate.value!);
    }

    if (selectedKind == LeaveApplyKind.festival &&
        selectedFestival.value != null) {
      data['festival_id'] = selectedFestival.value!.id;
    }

    if (selectedKind == LeaveApplyKind.compassionate &&
        (selectedRelative.value ?? '').isNotEmpty) {
      data['relative'] = selectedRelative.value;
    }

    final childAge = childAgeController.text.trim();
    if (selectedKind == LeaveApplyKind.parental && childAge.isNotEmpty) {
      data['child_age'] = childAge;
    }

    return data;
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
    final data = buildApplyLeaveData();
    final request = isEditMode
        ? ApplyLeaveService.updateLeave(
            id: editingLeaveId!,
            data: data,
            certificate: selectedCertificate,
          )
        : ApplyLeaveService.applyLeave(
            data: data,
            certificate: selectedCertificate,
          );
    request
        .then((value) {
          Get.back();
          Get.back(result: true);
          notificationHandler.sendNotification(
            message: isEditMode
                ? 'Leave request updated'
                : 'Leave request submitted',
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
    _employeeSearchDebounce?.cancel();
    remarksController.dispose();
    handoverPersonController.dispose();
    handoverSearchController.dispose();
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
