import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/controller/controller.dart';

class LeaveCalendar extends GetView<LeaveController> {
  const LeaveCalendar({super.key});

  static const _weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final month = controller.focusedMonth.value;
      final days = _daysInMonthGrid(month);

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(appSize.size16.w),
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
            Row(
              children: [
                _NavButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: controller.previousMonth,
                ),
                Expanded(
                  child: Text(
                    controller.monthLabel,
                    textAlign: TextAlign.center,
                    style: fontStyles.font16Black700,
                  ),
                ),
                _NavButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: controller.nextMonth,
                ),
              ],
            ),
            SizedBox(height: appSize.size16.h),
            Row(
              children: _weekDays
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: fontStyles.font12LightGrey500.copyWith(
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: appSize.size10.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: appSize.size6.h,
                crossAxisSpacing: 0,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                if (day == null) return const SizedBox.shrink();

                final selected = controller.isSelected(day);
                final inRange = controller.isInLeaveRange(day);
                final rangeStart = controller.isRangeStart(day);
                final rangeEnd = controller.isRangeEnd(day);
                final hasDot = controller.hasEventDot(day);

                return GestureDetector(
                  onTap: () => controller.onDateSelected(day),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (inRange)
                        Container(
                          height: 34.h,
                          margin: EdgeInsets.only(
                            left: rangeStart ? 8.w : 0,
                            right: rangeEnd ? 8.w : 0,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.brandColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(
                                rangeStart ? appSize.radius60 : 0,
                              ),
                              right: Radius.circular(
                                rangeEnd ? appSize.radius60 : 0,
                              ),
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
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: fontStyles.font12LightGrey500.copyWith(
                            letterSpacing: 0,
                            fontWeight: selected || rangeStart || rangeEnd
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected
                                ? appColors.whiteColor
                                : appColors.blackColor,
                          ),
                        ),
                      ),
                      if (hasDot && !selected)
                        Positioned(
                          bottom: 4.h,
                          child: Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              color: appColors.orangeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  List<DateTime?> _daysInMonthGrid(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmpty = firstDay.weekday % 7;

    return [
      ...List<DateTime?>.filled(leadingEmpty, null),
      ...List.generate(
        daysInMonth,
        (index) => DateTime(month.year, month.month, index + 1),
      ),
    ];
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius60),
      child: Padding(
        padding: EdgeInsets.all(appSize.size4.w),
        child: Icon(icon, color: appColors.mediumGreyColor, size: 24.sp),
      ),
    );
  }
}
