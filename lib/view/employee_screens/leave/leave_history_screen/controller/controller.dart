import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/service/service.dart';

import '../../../../../utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import '../../model/leave_model.dart';
import '../../model/leave_status_enum.dart';
import '../../model/leave_type_model.dart';

class LeaveHistoryController extends GetxController with Bindings {
  final RxBool showFilters = true.obs;

  final RxString selectedLeaveType = 'All Types'.obs;
  final RxString selectedYear = 'All Years'.obs;
  final RxString selectedMonth = 'All Months'.obs;
  final Rxn<DateTimeRange> selectedDateRange = Rxn();
  final Rxn<List<LeaveModel>> leave = Rxn(null);
  final RxList<LeaveTypeModel> leaveTypes = <LeaveTypeModel>[].obs;

  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int lastPage = 1;
  int totalRecords = 0;
  int _fetchId = 0;
  final RxInt filterVersion = 0.obs;

  List<String> get leaveTypeOptions => [
    'All Types',
    ...leaveTypes
        .map((type) => type.leaveName)
        .where((name) => name.isNotEmpty),
  ];

  final yearOptions = const ['All Years', '2026', '2025', '2024'];

  final monthOptions = const [
    'All Months',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get dateRangeLabel {
    final range = selectedDateRange.value;
    if (range == null) return 'Select Dates';
    final format = DateFormat('dd MMM');
    return '${format.format(range.start)} - ${format.format(range.end)}';
  }

  String get recordsCountLabel {
    final count = (totalRecords > 0 ? totalRecords : leave.value?.length ?? 0)
        .toString()
        .padLeft(2, '0');
    return 'Showing $count Leave Records';
  }

  @override
  void onInit() {
    getLeaveTypes();
    scrollController.addListener(() {
      if (scrollController.position.extentAfter == 0 &&
          currentPage <= lastPage) {
        if (currentPage != lastPage) {
          currentPage++;
          getLeaves();
        }
      }
    });
    super.onInit();
  }

  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  void onLeaveTypeChanged(String value) {
    selectedLeaveType.value = value;
    applyFilters();
  }

  void onYearChanged(String value) {
    selectedYear.value = value;
    applyFilters();
  }

  void onMonthChanged(String value) {
    selectedMonth.value = value;
    applyFilters();
  }

  void applyFilters() {
    onRefresh();
  }

  openOptionsSheet({
    required String title,
    required List<String> options,
    required String selected,
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
              margin: EdgeInsets.only(bottom: appSize.size8.h),
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size14.w,
                vertical: appSize.size14.h,
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

  Future<void> pickDateRange() async {
    final now = DateTime(2026, 7, 1);
    final picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027, 12, 31),

      initialDateRange:
          selectedDateRange.value ??
          DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
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
    if (picked != null) {
      selectedDateRange.value = picked;
      applyFilters();
    }
  }

  void clearDateRange() {
    selectedDateRange.value = null;
    applyFilters();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  LeaveTypeStyle typeStyle(LeaveType type) {
    switch (type.leaveType.toLowerCase()) {
      case "annual leave":
        return LeaveTypeStyle(
          bg: appColors.submittedBadgeBg,
          text: appColors.submittedBadgeText,
        );
      case "sick leave":
        return LeaveTypeStyle(
          bg: appColors.profileIconPurpleBg,
          text: appColors.profileIconPurple,
        );
      case "other":
        return LeaveTypeStyle(
          bg: appColors.profileIconTealBg,
          text: appColors.profileIconTeal,
        );
      default:
        return LeaveTypeStyle(
          bg: appColors.submittedBadgeBg,
          text: appColors.submittedBadgeText,
        );
    }
  }

  Color statusBg(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.requested:
        return appColors.pendingBadgeBg;
      case LeaveStatus.approved:
        return appColors.activeBadgeBg;
      case LeaveStatus.rejected:
        return appColors.rejectedBadgeBg;
    }
  }

  Color statusText(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.requested:
        return appColors.pendingBadgeText;
      case LeaveStatus.approved:
        return appColors.activeBadgeText;
      case LeaveStatus.rejected:
        return appColors.rejectedBadgeText;
    }
  }

  void onView(LeaveModel record) {
    Get.toNamed(appRoutes.leaveView, arguments: record.id);
  }

  void onEdit(LeaveModel record) {
    if (!record.canEdit) {
      notificationHandler.sendNotification(
        message: "Only requested leaves can be edited",
        notificationType: .warning,
      );
      return;
    }
    Get.toNamed(appRoutes.applyLeave, arguments: record.id)?.then((value) {
      if (value == true) onRefresh();
    });
  }

  Future<void> onRefresh() async {
    currentPage = 1;
    lastPage = 1;
    totalRecords = 0;
    leave.value = null;
    filterVersion.value++;
  }

  Future<List<LeaveTypeModel>> getLeaveTypes() async {
    return LeaveHistoryService.getLeaveTypes()
        .then((value) {
          leaveTypes.assignAll(value);
          return value;
        })
        .onError((error, stackTrace) {
          leaveTypes.clear();
          throw Exception("");
        });
  }

  Future<List<LeaveModel>> getLeaves() async {
    final fetchId = ++_fetchId;
    return LeaveHistoryService.getLeaves(page: currentPage, filters: {})
        .then((value) {
          if (fetchId != _fetchId) return value.leaves;
          currentPage = value.pagination.currentPage;
          lastPage = value.pagination.lastPage;
          totalRecords = value.pagination.totalPages;
          if (leave.value == null) {
            leave.value = value.leaves;
          } else {
            leave.value = [...leave.value!, ...value.leaves];
          }
          return value.leaves;
        })
        .onError((error, stackTrace) {
          if (fetchId != _fetchId) throw Exception("");
          if (leave.value == null) {
            leave.value = [];
          }
          throw Exception("");
        });
  }

  @override
  void dependencies() {
    Get.put(LeaveHistoryController());
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
