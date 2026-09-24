import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/constants/shared_data_key/shared_data_key.dart';

import '../../../../main.dart';
import '../../leave/leave_screen/service/model/leave_holiday_model.dart';
import '../service/model/event_calender_model.dart';
import '../service/service.dart';

class CalenderController extends GetxController with Bindings {
  late final String userId;

  final RxBool eventsLoading = RxBool(false);
  final RxList<Event> events = <Event>[].obs;
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rxn<DateTime> selectedDate = Rxn(DateTime.now());

  final RxBool holidaysLoading = false.obs;

  int? _loadedMonthKey;
  int _holidayFetchId = 0;

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

    return events
        .where((event) => event.occursOn(day))
        .map(
          (e) => CalendarDayDetail(
            title: e.title,
            dateLabel: dateLabel(e.startDatetime, e.endDatetime),
            badge: e.eventType.eventName,
            accent: e.eventType.eventName.toLowerCase().contains("leave")
                ? appColors.orangeColor
                : appColors.brandColor,
            badgeBg: appColors.acceptedBadgeBg,
            badgeText: appColors.acceptedBadgeText,
          ),
        )
        .toList();
  }

  @override
  void onInit() {
    getUserId();
    super.onInit();
  }

  Future<void> getUserId() async {
    userId = await sharedDataHandler.getSharedData(key: SharedDataKey.userId);
  }

  String selectedDateLabel() {
    final day = selectedDate.value;
    if (day == null) return '';
    return DateFormat('d MMM yyyy').format(day);
  }

  void onDateSelected(DateTime selected, DateTime focused) {
    selectedDate.value = selected;
    focusedMonth.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedMonth.value = focused;
    fetchEvents();
  }

  Object? _rangeKeyOn(DateTime day) {
    if (isMyInLeaveRange(day)) return 'holiday';
    return null;
  }

  bool isRangeEnd(DateTime day) {
    final key = _rangeKeyOn(day);
    if (key == null) return false;
    final next = DateTime(day.year, day.month, day.day + 1);
    return _rangeKeyOn(next) != key;
  }

  bool isRangeStart(DateTime day) {
    final key = _rangeKeyOn(day);
    if (key == null) return false;
    final previous = DateTime(day.year, day.month, day.day - 1);
    return _rangeKeyOn(previous) != key;
  }

  Color? rangeColorOn(DateTime day) {
    if (isMyInLeaveRange(day)) {
      return appColors.brandColor.withValues(alpha: 0.14);
    }
    return null;
  }

  bool isMyInLeaveRange(DateTime day) {
    return events.any((item) {
      return item.employee?.user.id.toString() == userId
          ? item.occursOn(day)
          : false;
    });
  }

  List<Event> festivalsOn(DateTime day) {
    return events.where((item) => item.occursOn(day)).toList();
  }

  int _monthKey(DateTime date) => date.year * 100 + date.month;

  Future<void> fetchEvents() async {
    final month = focusedMonth.value.month;
    final monthKey = _monthKey(focusedMonth.value);
    if (_loadedMonthKey == monthKey) return;

    final fetchId = ++_holidayFetchId;
    _loadedMonthKey = monthKey;
    holidaysLoading.value = true;
    events.clear();
    try {
      final result = await EventCalenderService.getEvents(
        month: month,
        year: focusedMonth.value.year,
      );
      if (fetchId != _holidayFetchId) return;
      events.assignAll(result.events);
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

  @override
  void dependencies() {
    Get.put(CalenderController());
  }
}
