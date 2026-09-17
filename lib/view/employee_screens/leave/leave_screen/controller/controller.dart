import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_event_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_holiday_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/view/widgets/leave_balance_bottom_sheet.dart';

class LeaveController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rxn<DateTime> selectedDate = Rxn(DateTime.now());
  final RxList<LeaveHolidayItem> festivals = <LeaveHolidayItem>[].obs;
  final RxList<LeaveHolidayItem> holidays = <LeaveHolidayItem>[].obs;
  final RxList<CalendarAppliedLeave> appliedLeaves = <CalendarAppliedLeave>[].obs;
  final RxBool holidaysLoading = false.obs;

  int _holidayFetchId = 0;
  int? _loadedMonthKey;

  late final List<LeaveActionModel> actions = [
    LeaveActionModel(
      title: 'Apply Leave',
      icon: Icons.event_available_outlined,
      color: appColors.brandColor,
    ),
    LeaveActionModel(
      title: 'Leave Balance',
      icon: Icons.fact_check_outlined,
      color: appColors.tileTeal,
    ),
    LeaveActionModel(
      title: 'Leave History',
      icon: Icons.history_rounded,
      color: appColors.orangeColor,
    ),
    LeaveActionModel(
      title: 'Travel',
      icon: Icons.flight_outlined,
      color: appColors.tileSky,
    ),
    LeaveActionModel(
      title: 'Work From Home',
      icon: Icons.home_outlined,
      color: appColors.tilePurple,
    ),
  ];

  int _monthKey(DateTime date) => date.year * 100 + date.month;

  @override
  void onInit() {
    fetchHolidays();
    super.onInit();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedDate.value = selected;
    focusedMonth.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedMonth.value = focused;
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    final month = focusedMonth.value.month;
    final monthKey = _monthKey(focusedMonth.value);
    if (_loadedMonthKey == monthKey) return;

    final fetchId = ++_holidayFetchId;
    _loadedMonthKey = monthKey;
    holidaysLoading.value = true;
    festivals.clear();
    holidays.clear();
    appliedLeaves.clear();
    try {
      final result = await LeaveCalendarService.getHolidays(
        month: month,
        year: focusedMonth.value.year,
      );
      if (fetchId != _holidayFetchId) return;
      festivals.assignAll(result.festivals);
      holidays.assignAll(result.holidays);
      appliedLeaves.assignAll(result.leaves);
    } catch (_) {
      if (fetchId != _holidayFetchId) return;
      _loadedMonthKey = null;
      notificationHandler.sendNotification(
        message: 'Unable to load holidays',
        notificationType: .error,
      );
    } finally {
      if (fetchId == _holidayFetchId) {
        holidaysLoading.value = false;
      }
    }
  }

  void onActionTap(LeaveActionModel action) {
    switch (action.title) {
      case 'Apply Leave':
        Get.toNamed(appRoutes.applyLeave);
        break;
      case 'Leave Balance':
        showLeaveBalanceBottomSheet();
        break;
      case 'Leave History':
        Get.toNamed(appRoutes.leaveHistory);
        break;
      default:
        notificationHandler.sendNotification(
          message: "${action.title} coming soon",
          notificationType: .warning,
        );
    }
  }

  bool isSelected(DateTime day) {
    final selected = selectedDate.value;
    if (selected == null) return false;
    return selected.year == day.year &&
        selected.month == day.month &&
        selected.day == day.day;
  }

  List<LeaveHolidayItem> festivalsOn(DateTime day) {
    return festivals.where((item) => item.occursOn(day)).toList();
  }

  AppliedLeaveTone? leaveToneOn(DateTime day) {
    final tones = appliedLeaves
        .where((item) => item.occursOn(day))
        .map((item) => item.tone)
        .toSet();
    if (tones.contains(AppliedLeaveTone.pending)) {
      return AppliedLeaveTone.pending;
    }
    if (tones.contains(AppliedLeaveTone.approvedUpcoming)) {
      return AppliedLeaveTone.approvedUpcoming;
    }
    if (tones.contains(AppliedLeaveTone.approvedPast)) {
      return AppliedLeaveTone.approvedPast;
    }
    return null;
  }

  Color leaveToneColor(AppliedLeaveTone tone) {
    switch (tone) {
      case AppliedLeaveTone.pending:
        return appColors.orangeColor;
      case AppliedLeaveTone.approvedUpcoming:
        return appColors.checkOutGreen;
      case AppliedLeaveTone.approvedPast:
        return appColors.tileSteel;
    }
  }

  Color? rangeColorOn(DateTime day) {
    final tone = leaveToneOn(day);
    if (tone != null) {
      return leaveToneColor(tone).withValues(alpha: 0.22);
    }
    if (isInHolidayRange(day)) {
      return appColors.brandColor.withValues(alpha: 0.14);
    }
    return null;
  }

  Object? _rangeKeyOn(DateTime day) {
    final tone = leaveToneOn(day);
    if (tone != null) return tone;
    if (isInHolidayRange(day)) return 'holiday';
    return null;
  }

  bool isRangeStart(DateTime day) {
    final key = _rangeKeyOn(day);
    if (key == null) return false;
    final previous = DateTime(day.year, day.month, day.day - 1);
    return _rangeKeyOn(previous) != key;
  }

  bool isRangeEnd(DateTime day) {
    final key = _rangeKeyOn(day);
    if (key == null) return false;
    final next = DateTime(day.year, day.month, day.day + 1);
    return _rangeKeyOn(next) != key;
  }

  List<CalendarDayDetail> get selectedDateItems {
    final day = selectedDate.value;
    if (day == null) return const [];
    final format = DateFormat('d MMM');
    String dateLabel(DateTime start, DateTime end) {
      final startDay = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(end.year, end.month, end.day);
      if (startDay == endDay) return format.format(start);
      return '${format.format(start)} - ${format.format(end)}';
    }

    return [
      ...festivals.where((item) => item.occursOn(day)).map((item) {
        return CalendarDayDetail(
          title: item.name,
          dateLabel: dateLabel(item.startDate, item.endDate),
          badge: 'Festival',
          accent: appColors.orangeColor,
          badgeBg: appColors.acceptedBadgeBg,
          badgeText: appColors.acceptedBadgeText,
        );
      }),
      ...holidays.where((item) => item.occursOn(day)).map((item) {
        return CalendarDayDetail(
          title: item.name,
          dateLabel: dateLabel(item.startDate, item.endDate),
          badge: 'Holiday',
          accent: appColors.brandColor,
          badgeBg: appColors.submittedBadgeBg,
          badgeText: appColors.submittedBadgeText,
        );
      }),
      ...appliedLeaves.where((item) => item.occursOn(day)).map((item) {
        return CalendarDayDetail(
          title: item.name,
          dateLabel: dateLabel(item.startDate, item.endDate),
          badge: _leaveBadgeLabel(item.tone),
          accent: leaveToneColor(item.tone),
          badgeBg: _leaveBadgeBg(item.tone),
          badgeText: _leaveBadgeText(item.tone),
        );
      }),
    ];
  }

  String _leaveBadgeLabel(AppliedLeaveTone tone) {
    switch (tone) {
      case AppliedLeaveTone.pending:
        return 'Pending';
      case AppliedLeaveTone.approvedUpcoming:
        return 'Approved';
      case AppliedLeaveTone.approvedPast:
        return 'Past';
    }
  }

  Color _leaveBadgeBg(AppliedLeaveTone tone) {
    switch (tone) {
      case AppliedLeaveTone.pending:
        return appColors.pendingBadgeBg;
      case AppliedLeaveTone.approvedUpcoming:
        return appColors.activeBadgeBg;
      case AppliedLeaveTone.approvedPast:
        return appColors.scaffoldGreyColor;
    }
  }

  Color _leaveBadgeText(AppliedLeaveTone tone) {
    switch (tone) {
      case AppliedLeaveTone.pending:
        return appColors.pendingBadgeText;
      case AppliedLeaveTone.approvedUpcoming:
        return appColors.activeBadgeText;
      case AppliedLeaveTone.approvedPast:
        return appColors.mediumGreyColor;
    }
  }

  String selectedDateLabel() {
    final day = selectedDate.value;
    if (day == null) return '';
    return DateFormat('d MMM yyyy').format(day);
  }

  bool isInHolidayRange(DateTime day) {
    return holidays.any((item) => item.occursOn(day));
  }

  String eventDateLabel(LeaveEventModel event) {
    final format = DateFormat('d MMM');
    if (!event.isRange) return format.format(event.startDate);
    return '${format.format(event.startDate)} - ${format.format(event.endDate)}';
  }

  String badgeLabel(LeaveEventBadge badge) {
    switch (badge) {
      case LeaveEventBadge.approved:
        return 'Approved';
      case LeaveEventBadge.businessTrip:
        return 'Business Trip';
    }
  }

  Color badgeBg(LeaveEventBadge badge) {
    switch (badge) {
      case LeaveEventBadge.approved:
        return appColors.activeBadgeBg;
      case LeaveEventBadge.businessTrip:
        return appColors.submittedBadgeBg;
    }
  }

  Color badgeText(LeaveEventBadge badge) {
    switch (badge) {
      case LeaveEventBadge.approved:
        return appColors.activeBadgeText;
      case LeaveEventBadge.businessTrip:
        return appColors.submittedBadgeText;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(LeaveController());
  }
}
