import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/view/widgets/leave_history_card.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/view/widgets/leave_history_filter_field.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/view/widgets/leave_record_body.dart';

class LeaveHistoryView extends GetView<LeaveHistoryController> {
  const LeaveHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(
        title: "Leave History",
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AppBarIcon(
              icon: Icons.tune_rounded,
              onTap: controller.toggleFilters,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (!controller.showFilters.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  appSize.size16.w,
                  appSize.size8.h,
                  appSize.size16.w,
                  0,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(appSize.size14.w),
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
                          Expanded(
                            child: Obx(
                              () => LeaveHistoryFilterField(
                                label: 'LEAVE TYPE',
                                value: controller.selectedLeaveType.value,
                                onTap: () => controller.openOptionsSheet(
                                  title: 'Leave Type',
                                  options: controller.leaveTypeOptions,
                                  selected: controller.selectedLeaveType.value,
                                  onSelected: controller.onLeaveTypeChanged,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: appSize.size12.w),
                          Expanded(
                            child: Obx(
                              () => LeaveHistoryFilterField(
                                label: 'YEAR',
                                value: controller.selectedYear.value,
                                onTap: () => controller.openOptionsSheet(
                                  title: 'Year',
                                  options: controller.yearOptions,
                                  selected: controller.selectedYear.value,
                                  onSelected: controller.onYearChanged,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: appSize.size12.h),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => LeaveHistoryFilterField(
                                label: 'MONTH',
                                value: controller.selectedMonth.value,
                                onTap: () => controller.openOptionsSheet(
                                  title: 'Month',
                                  options: controller.monthOptions,
                                  selected: controller.selectedMonth.value,
                                  onSelected: controller.onMonthChanged,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: appSize.size12.w),
                          Expanded(
                            child: Obx(
                              () => LeaveHistoryFilterField(
                                label: 'DATE RANGE',
                                value: controller.dateRangeLabel,
                                leading: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14.sp,
                                  color: appColors.lightGreyColor,
                                ),
                                onTap: controller.pickDateRange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                return FutureBuilder(
                  key: ValueKey(controller.filterVersion.value),
                  future: controller.leave.value == null
                      ? controller.getLeaves()
                      : null,
                  builder: (context, snapshot) {
                    return RefreshIndicator(
                      onRefresh: controller.onRefresh,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                appSize.size16.w,
                                appSize.size16.h,
                                appSize.size16.w,
                                appSize.size8.h,
                              ),
                              child: Text(
                                controller.recordsCountLabel,
                                style: fontStyles.font12LightGrey500.copyWith(
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            LeaveRecordBody(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius60),
      child: SizedBox(
        width: 40.w,
        height: 40.w,
        child: Icon(icon, color: appColors.blackColor, size: 22.sp),
      ),
    );
  }
}
