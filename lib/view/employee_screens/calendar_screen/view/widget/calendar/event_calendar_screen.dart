import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/controller/controller.dart';

import '../../../controller/controller.dart';
import 'widget/day_cell.dart';

class EventCalenderScreen extends GetView<CalenderController> {
  const EventCalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final focused = controller.focusedMonth.value;
      final selected = controller.selectedDate.value;
      return FutureBuilder(
        future: controller.fetchEvents(),
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              appSize.size8.w,
              appSize.size12.h,
              appSize.size8.w,
              appSize.size12.h,
            ),
            decoration: BoxDecoration(
              color: appColors.whiteColor,
              borderRadius: BorderRadius.circular(appSize.radius16),
              boxShadow: [
                BoxShadow(
                  color: appColors.blackColor.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.now().subtract(Duration(days: 365 * 5)),
                  lastDay: DateTime.now().add(Duration(days: 365 * 5)),
                  focusedDay: focused,
                  selectedDayPredicate: (day) =>
                      selected != null && isSameDay(selected, day),
                  onDaySelected: controller.onDateSelected,
                  onPageChanged: controller.onPageChanged,
                  // eventLoader: controller.festivalsOn,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  sixWeekMonthsEnforced: false,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  daysOfWeekHeight: 28.h,
                  rowHeight: 42.h,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    headerPadding: EdgeInsets.symmetric(
                      vertical: appSize.size4.h,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left_rounded,
                      color: appColors.mediumGreyColor,
                      size: 24.sp,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right_rounded,
                      color: appColors.mediumGreyColor,
                      size: 24.sp,
                    ),
                    titleTextStyle: fontStyles.font16Black700,
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
                    dowTextFormatter: (date, locale) =>
                        ['S', 'M', 'T', 'W', 'T', 'F', 'S'][date.weekday % 7],
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    isTodayHighlighted: true,
                    cellMargin: EdgeInsets.zero,
                    defaultTextStyle: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      color: appColors.blackColor,
                    ),
                    weekendTextStyle: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      color: appColors.blackColor,
                    ),
                    selectedTextStyle: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      color: appColors.whiteColor,
                    ),
                    todayTextStyle: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                      color: appColors.brandColor,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: appColors.brandColor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: appColors.brandColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final rangeColor = controller.rangeColorOn(day);
                      final rangeStart = controller.isRangeStart(day);
                      final rangeEnd = controller.isRangeEnd(day);
                      final hasEvent = controller.festivalsOn(day).isNotEmpty;
                      bool hasLeave = controller
                          .festivalsOn(day)
                          .any(
                            (element) => element.eventType.eventName
                                .toLowerCase()
                                .contains("leave"),
                          );
                      return DayCell(
                        rangeStart: rangeStart,
                        rangeEnd: rangeEnd,
                        selected: false,
                        today: false,
                        hasEvent: hasEvent,
                        hasLeave: hasLeave,
                        day: day,
                        rangeColor: rangeColor,
                      );
                    },
                    todayBuilder: (context, day, focusedDay)  {
                      final rangeColor = controller.rangeColorOn(day);
                      final rangeStart = controller.isRangeStart(day);
                      final rangeEnd = controller.isRangeEnd(day);
                      final hasEvent = controller.festivalsOn(day).isNotEmpty;
                      bool hasLeave = controller
                          .festivalsOn(day)
                          .any(
                            (element) => element.eventType.eventName
                            .toLowerCase()
                            .contains("leave"),
                      );
                      return DayCell(
                        rangeStart: rangeStart,
                        rangeEnd: rangeEnd,
                        selected: selected != null && isSameDay(selected, day),
                        today: true,
                        hasEvent: hasEvent,
                        hasLeave: hasLeave,
                        day: day,
                        rangeColor: rangeColor,
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final rangeColor = controller.rangeColorOn(day);
                      final rangeStart = controller.isRangeStart(day);
                      final rangeEnd = controller.isRangeEnd(day);
                      final hasEvent = controller.festivalsOn(day).isNotEmpty;
                      bool hasLeave = controller
                          .festivalsOn(day)
                          .any(
                            (element) => element.eventType.eventName
                            .toLowerCase()
                            .contains("leave"),
                      );
                      return DayCell(
                        rangeStart: rangeStart,
                        rangeEnd: rangeEnd,
                        selected: true,
                        today: false,
                        hasEvent: hasEvent,
                        hasLeave: hasLeave,
                        day: day,
                        rangeColor: rangeColor,
                      );
                    },
                  ),
                ),
                if (controller.eventsLoading.value)
                  Padding(
                    padding: EdgeInsets.only(top: appSize.size8.h),
                    child: Text(
                      'Loading EVents',
                      style: fontStyles.font12LightGrey500.copyWith(
                        letterSpacing: 0,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }
}
