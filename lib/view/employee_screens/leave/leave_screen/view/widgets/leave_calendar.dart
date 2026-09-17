import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/controller/controller.dart';

class LeaveCalendar extends GetView<LeaveController> {
  const LeaveCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final focused = controller.focusedMonth.value;
      final selected = controller.selectedDate.value;
      controller.festivals.length;
      controller.holidays.length;
      controller.appliedLeaves.length;

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
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2035, 12, 31),
              focusedDay: focused,
              selectedDayPredicate: (day) =>
                  selected != null && isSameDay(selected, day),
              onDaySelected: controller.onDateSelected,
              onPageChanged: controller.onPageChanged,
              eventLoader: controller.festivalsOn,
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              startingDayOfWeek: StartingDayOfWeek.sunday,
              sixWeekMonthsEnforced: false,
              availableGestures: AvailableGestures.horizontalSwipe,
              daysOfWeekHeight: 28.h,
              rowHeight: 42.h,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                headerPadding: EdgeInsets.symmetric(vertical: appSize.size4.h),
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
                markersMaxCount: 1,
                markerSize: 5.w,
                markerDecoration: BoxDecoration(
                  color: appColors.orangeColor,
                  shape: BoxShape.circle,
                ),
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
                defaultBuilder: (context, day, focusedDay) =>
                    _dayCell(day, selected: false, today: false),
                todayBuilder: (context, day, focusedDay) => _dayCell(
                  day,
                  selected: selected != null && isSameDay(selected, day),
                  today: true,
                ),
                selectedBuilder: (context, day, focusedDay) =>
                    _dayCell(day, selected: true, today: false),
              ),
            ),
            if (controller.holidaysLoading.value)
              Padding(
                padding: EdgeInsets.only(top: appSize.size8.h),
                child: Text(
                  'Leaves loading',
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.fromLTRB(
                  appSize.size8.w,
                  appSize.size10.h,
                  appSize.size8.w,
                  0,
                ),
                child: Wrap(
                  spacing: appSize.size12.w,
                  runSpacing: appSize.size6.h,
                  alignment: WrapAlignment.center,
                  children: [
                    _LegendDot(
                      color: appColors.orangeColor,
                      label: 'Pending',
                    ),
                    _LegendDot(
                      color: appColors.checkOutGreen,
                      label: 'Approved',
                    ),
                    _LegendDot(color: appColors.tileSteel, label: 'Past'),
                    _LegendDot(color: appColors.brandColor, label: 'Holiday'),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _dayCell(DateTime day, {required bool selected, required bool today}) {
    final rangeColor = controller.rangeColorOn(day);
    final rangeStart = controller.isRangeStart(day);
    final rangeEnd = controller.isRangeEnd(day);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (rangeColor != null)
          Container(
            height: 34.h,
            margin: EdgeInsets.only(
              left: rangeStart ? 8.w : 0,
              right: rangeEnd ? 8.w : 0,
            ),
            decoration: BoxDecoration(
              color: rangeColor,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(rangeStart ? appSize.radius60 : 0),
                right: Radius.circular(rangeEnd ? appSize.radius60 : 0),
              ),
            ),
          ),
        Container(
          width: 34.w,
          height: 34.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? appColors.brandColor
                : today
                ? appColors.brandColor.withValues(alpha: 0.12)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${day.day}',
            style: fontStyles.font12LightGrey500.copyWith(
              letterSpacing: 0,
              fontWeight: selected || today || rangeStart || rangeEnd
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: selected
                  ? appColors.whiteColor
                  : today
                  ? appColors.brandColor
                  : appColors.blackColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: fontStyles.font10LightGrey500.copyWith(
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
