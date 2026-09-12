import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';
import 'package:yes_hrm/view/employee_screens/visits/request_visit_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/visits/request_visit_screen/view/widgets/assigned_employees_sheet.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class RequestVisitController extends GetxController with Bindings {
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController visitorNameController = TextEditingController();
  final TextEditingController visitorDesignationController =
      TextEditingController();
  final TextEditingController employeeSearchController =
      TextEditingController();

  final approvers = const [
    'Mohammed Hassan, HR Director',
    'Priya Nair, HR Manager',
    'Ahmed Hassan, Team Lead',
  ];

  final RxnString selectedVisitType = RxnString();
  final Rxn<DateTime> expectedStartDate = Rxn();
  final Rxn<TimeOfDay> expectedStartTime = Rxn();
  final Rxn<DateTime> expectedEndDate = Rxn();
  final Rxn<TimeOfDay> expectedEndTime = Rxn();
  final RxList<VisitVisitor> visitors = <VisitVisitor>[].obs;
  final RxList<EmployeeModel> assignedEmployees = <EmployeeModel>[].obs;
  final RxList<EmployeeModel> pendingAssignedEmployees = <EmployeeModel>[].obs;
  final RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  final RxBool employeesLoading = false.obs;
  final RxBool employeesHasError = false.obs;
  final RxString employeeSearchQuery = ''.obs;
  Timer? _employeeSearchDebounce;
  final RxnString selectedApprover = RxnString();
  final RxList<XFile> attachments = <XFile>[].obs;

  String get expectedStartDateLabel => _dateLabel(expectedStartDate.value);

  String get expectedEndDateLabel => _dateLabel(expectedEndDate.value);

  String get expectedStartTimeLabel => _timeLabel(expectedStartTime.value);

  String get expectedEndTimeLabel => _timeLabel(expectedEndTime.value);

  String _dateLabel(DateTime? date) {
    if (date == null) return 'Select date';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _timeLabel(TimeOfDay? time) {
    if (time == null) return 'Select time';
    final dt = DateTime(2026, 1, 1, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  List<EmployeeModel> get filteredEmployees {
    final query = employeeSearchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return employees.toList();
    return employees.where((employee) {
      return employee.name.toLowerCase().contains(query) ||
          employee.designation.toLowerCase().contains(query);
    }).toList();
  }

  DateTime? _combinedDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

  Future<void> pickExpectedStartDate() async {
    final picked = await _pickDate(expectedStartDate.value);
    if (picked == null) return;
    expectedStartDate.value = picked;
    if (expectedEndDate.value == null ||
        expectedEndDate.value!.isBefore(picked)) {
      expectedEndDate.value = picked;
    }
  }

  Future<void> pickExpectedEndDate() async {
    final picked = await _pickDate(
      expectedEndDate.value ?? expectedStartDate.value,
      firstDate: expectedStartDate.value,
    );
    if (picked != null) expectedEndDate.value = picked;
  }

  Future<void> pickExpectedStartTime() async {
    final picked = await _pickTime(expectedStartTime.value);
    if (picked != null) expectedStartTime.value = picked;
  }

  Future<void> pickExpectedEndTime() async {
    final picked = await _pickTime(expectedEndTime.value);
    if (picked != null) expectedEndTime.value = picked;
  }

  Future<DateTime?> _pickDate(DateTime? current, {DateTime? firstDate}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final minDate = firstDate == null
        ? today
        : DateTime(firstDate.year, firstDate.month, firstDate.day);
    final initial = current ?? minDate;
    return showDatePicker(
      context: Get.context!,
      initialDate: initial.isBefore(minDate) ? minDate : initial,
      firstDate: minDate,
      lastDate: DateTime(2030),
      builder: _pickerTheme,
    );
  }

  Future<TimeOfDay?> _pickTime(TimeOfDay? current) {
    return showTimePicker(
      context: Get.context!,
      initialTime: current ?? TimeOfDay.now(),
      builder: _pickerTheme,
    );
  }

  Widget _pickerTheme(BuildContext context, Widget? child) {
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
  }

  void onAddVisitorTap() {
    visitorNameController.clear();
    visitorDesignationController.clear();
    customBottomSheet(
      title: 'Add Visitor',
      child: Column(
        children: [
          CustomTextField(
            title: 'Name',
            controller: visitorNameController,
            hintText: 'Enter visitor name',
            radius: appSize.radius12,
            maxLines: 1,
          ),
          SizedBox(height: appSize.size16.h),
          CustomTextField(
            title: 'Designation',
            controller: visitorDesignationController,
            hintText: 'Enter designation',
            radius: appSize.radius12,
            maxLines: 1,
          ),
          SizedBox(height: appSize.size20.h),
          CustomButton(
            buttonWidth: double.infinity,
            buttonName: 'Add Visitor',
            onPressed: () {
              final name = visitorNameController.text.trim();
              final designation = visitorDesignationController.text.trim();
              if (name.isEmpty) {
                notificationHandler.sendNotification(
                  message: 'Enter visitor name',
                  notificationType: .warning,
                );
                return;
              }
              if (designation.isEmpty) {
                notificationHandler.sendNotification(
                  message: 'Enter visitor designation',
                  notificationType: .warning,
                );
                return;
              }
              visitors.add(
                VisitVisitor(name: name, designation: designation),
              );
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void removeVisitor(int index) {
    if (index < 0 || index >= visitors.length) return;
    visitors.removeAt(index);
  }

  void onAssignEmployeesTap() {
    employeeSearchController.clear();
    employeeSearchQuery.value = '';
    pendingAssignedEmployees.assignAll(assignedEmployees);
    fetchEmployees();
    customBottomSheet(
      title: 'Assigned Employees',
      child: const AssignedEmployeesSheet(),
    );
  }

  void onEmployeeSearchChanged(String value) {
    employeeSearchQuery.value = value;
    _employeeSearchDebounce?.cancel();
    _employeeSearchDebounce = Timer(const Duration(milliseconds: 400), () {
      fetchEmployees(search: value);
    });
  }

  void togglePendingEmployee(EmployeeModel employee) {
    final exists = pendingAssignedEmployees.any((item) => item.id == employee.id);
    if (exists) {
      pendingAssignedEmployees.removeWhere((item) => item.id == employee.id);
    } else {
      pendingAssignedEmployees.add(employee);
    }
  }

  void confirmAssignedEmployees() {
    assignedEmployees.assignAll(pendingAssignedEmployees);
    Get.back();
  }

  void removeEmployee(EmployeeModel employee) {
    assignedEmployees.removeWhere((item) => item.id == employee.id);
  }

  Future<void> fetchEmployees({String? search}) async {
    employeesLoading.value = true;
    employeesHasError.value = false;
    try {
      final result = await RequestVisitService.getEmployees(search: search);
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
    if (visitors.isEmpty) {
      notificationHandler.sendNotification(
        message: 'Add at least one visitor',
        notificationType: .warning,
      );
      return;
    }
    if (companyController.text.trim().isEmpty) {
      notificationHandler.sendNotification(
        message: 'Enter company name',
        notificationType: .warning,
      );
      return;
    }
    if (contactController.text.trim().isEmpty) {
      notificationHandler.sendNotification(
        message: 'Enter contact number',
        notificationType: .warning,
      );
      return;
    }
    final email = emailController.text.trim();
    if (email.isEmpty || !_isValidEmail(email)) {
      notificationHandler.sendNotification(
        message: 'Enter a valid email',
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
    final start = _combinedDateTime(
      expectedStartDate.value,
      expectedStartTime.value,
    );
    final end = _combinedDateTime(
      expectedEndDate.value,
      expectedEndTime.value,
    );
    if (start == null || end == null) {
      notificationHandler.sendNotification(
        message: 'Select start and end date & time',
        notificationType: .warning,
      );
      return;
    }
    if (!end.isAfter(start)) {
      notificationHandler.sendNotification(
        message: 'End time must be after start time',
        notificationType: .warning,
      );
      return;
    }

    loadingScreen();
    RequestVisitService.createVisit(
          visitors: visitors.toList(),
          company: companyController.text.trim(),
          contactNo: contactController.text.trim(),
          email: email,
          purpose: purposeController.text.trim(),
          location: locationController.text.trim(),
          expectedStartDate: start,
          expectedEndDate: end,
          assignedEmployeeIds:
              assignedEmployees.map((employee) => employee.id).toList(),
        )
        .then((value) {
          Get.back();
          Get.back(result: true);
          notificationHandler.sendNotification(
            message: 'Visit request submitted',
            notificationType: .success,
          );
        })
        .onError((error, stackTrace) {
          Get.back();
          notificationHandler.apiErrorNotificationHandler(error: error);
        });
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
  }

  @override
  void onClose() {
    _employeeSearchDebounce?.cancel();
    purposeController.dispose();
    locationController.dispose();
    companyController.dispose();
    contactController.dispose();
    emailController.dispose();
    remarksController.dispose();
    visitorNameController.dispose();
    visitorDesignationController.dispose();
    employeeSearchController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(RequestVisitController());
  }
}
