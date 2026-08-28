import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/service/service.dart';

import '../../model/leave_model.dart';
import '../../model/leave_status_enum.dart';
import '../../model/leave_type_enum.dart';



class LeaveHistoryController extends GetxController with Bindings {
  final RxBool showFilters = true.obs;

  final RxString selectedLeaveType = 'All Types'.obs;
  final RxString selectedYear = '2026'.obs;
  final RxString selectedMonth = 'All Months'.obs;
  final Rxn<DateTimeRange> selectedDateRange = Rxn();
  final Rxn<List> leave = Rxn(null);

  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  int lastPage = 1;

  final leaveTypeOptions = const ['All Types', 'Annual Leave', 'Sick Leave'];

  final yearOptions = const ['2026', '2025', '2024'];

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

  late final List<LeaveModel> records = [
    LeaveModel(
      id: '1',
      type: LeaveType.annualLeave,
      status: LeaveStatus.requested,
      fromDate: DateTime(2026, 7, 25),
      toDate: DateTime(2026, 8, 25),
      appliedOn: DateTime(2026, 7, 20),
    ),
    LeaveModel(
      id: '2',
      type: LeaveType.sickLeave,
      status: LeaveStatus.approved,
      fromDate: DateTime(2026, 7, 14),
      toDate: DateTime(2026, 7, 15),
      appliedOn: DateTime(2026, 7, 12),
    ),
    LeaveModel(
      id: '3',
      type: LeaveType.annualLeave,
      status: LeaveStatus.rejected,
      fromDate: DateTime(2026, 6, 1),
      toDate: DateTime(2026, 6, 5),
      appliedOn: DateTime(2026, 5, 28),
    ),
    LeaveModel(
      id: '4',
      type: LeaveType.sickLeave,
      status: LeaveStatus.requested,
      fromDate: DateTime(2026, 8, 10),
      toDate: DateTime(2026, 8, 12),
      appliedOn: DateTime(2026, 8, 5),
    ),
  ];

  List<LeaveModel> get filteredRecords {
    return records.where((record) {
      if (selectedLeaveType.value != 'All Types' &&
          record.type.label != selectedLeaveType.value) {
        return false;
      }

      if (record.fromDate.year.toString() != selectedYear.value &&
          record.toDate.year.toString() != selectedYear.value) {
        return false;
      }

      if (selectedMonth.value != 'All Months') {
        final monthIndex = monthOptions.indexOf(selectedMonth.value);
        final matchesMonth =
            record.fromDate.month == monthIndex ||
            record.toDate.month == monthIndex;
        if (!matchesMonth) return false;
      }

      final range = selectedDateRange.value;
      if (range != null) {
        final overlaps =
            !record.toDate.isBefore(range.start) &&
            !record.fromDate.isAfter(range.end);
        if (!overlaps) return false;
      }

      return true;
    }).toList();
  }

  String get recordsCountLabel {
    final count = filteredRecords.length.toString().padLeft(2, '0');
    return 'Showing $count Leave Records';
  }

  String get dateRangeLabel {
    final range = selectedDateRange.value;
    if (range == null) return 'Select Dates';
    final format = DateFormat('dd MMM');
    return '${format.format(range.start)} - ${format.format(range.end)}';
  }

  @override
  void onInit() {
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
  }

  void onYearChanged(String value) {
    selectedYear.value = value;
  }

  void onMonthChanged(String value) {
    selectedMonth.value = value;
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
    }
  }

  void clearDateRange() {
    selectedDateRange.value = null;
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  LeaveTypeStyle typeStyle(LeaveType type) {
    switch (type) {
      case LeaveType.annualLeave:
        return LeaveTypeStyle(
          bg: appColors.submittedBadgeBg,
          text: appColors.submittedBadgeText,
        );
      case LeaveType.sickLeave:
        return LeaveTypeStyle(
          bg: appColors.profileIconPurpleBg,
          text: appColors.profileIconPurple,
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
    notificationHandler.sendNotification(
      message: "View ${record.type.label}",
      notificationType: .success,
    );
  }

  void onEdit(LeaveModel record) {
    notificationHandler.sendNotification(
      message: "Edit ${record.type.label}",
      notificationType: .warning,
    );
  }

  Future getLeaves() async {
    return LeaveHistoryService.getLeaves(page: currentPage)
        .then((value) {
          currentPage = value.pagination.currentPage;
          lastPage = value.pagination.lastPage;
          if (leave.value == null) {
            leave.value = value.leaves;
          } else {
            leave.value = leave.value! + value.leaves;
          }
          return value.leaves;
        })
        .onError((error, stackTrace) {
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
}
