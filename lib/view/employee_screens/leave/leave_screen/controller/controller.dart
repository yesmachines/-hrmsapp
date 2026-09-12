import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/service/model/leave_event_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/view/widgets/leave_balance_bottom_sheet.dart';

class LeaveController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<DateTime> focusedMonth = DateTime(2026, 7).obs;
  final Rxn<DateTime> selectedDate = Rxn(DateTime(2026, 7, 16));

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


  String get monthLabel => DateFormat('MMMM yyyy').format(focusedMonth.value);

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void previousMonth() {
    final current = focusedMonth.value;
    focusedMonth.value = DateTime(current.year, current.month - 1);
  }

  void nextMonth() {
    final current = focusedMonth.value;
    focusedMonth.value = DateTime(current.year, current.month + 1);
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
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

  // bool isInLeaveRange(DateTime day) {
  //   return events.any(
  //     (event) =>
  //         event.badge == LeaveEventBadge.approved &&
  //         event.isRange &&
  //         event.occursOn(day),
  //   );
  // }

  // bool isRangeStart(DateTime day) {
  //   return events.any(
  //     (event) =>
  //         event.isRange &&
  //         event.startDate.year == day.year &&
  //         event.startDate.month == day.month &&
  //         event.startDate.day == day.day,
  //   );
  // }

  // bool isRangeEnd(DateTime day) {
  //   return events.any(
  //     (event) =>
  //         event.isRange &&
  //         event.endDate.year == day.year &&
  //         event.endDate.month == day.month &&
  //         event.endDate.day == day.day,
  //   );
  // }

  // bool hasEventDot(DateTime day) {
  //   return events.any(
  //     (event) => event.occursOn(day) && !isInLeaveRange(day),
  //   );
  // }

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
