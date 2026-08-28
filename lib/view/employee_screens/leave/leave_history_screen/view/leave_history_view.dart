import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/view/widgets/leave_history_card.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_history_screen/view/widgets/leave_history_filter_field.dart';

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
            SizedBox(width: appSize.size4.w),
            _AppBarIcon(
              icon: Icons.calendar_month_outlined,
              onTap: controller.pickDateRange,
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
                                onTap: () => _openOptionsSheet(
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
                                onTap: () => _openOptionsSheet(
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
                                onTap: () => _openOptionsSheet(
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
              child: FutureBuilder(
                future: controller.getLeaves(),
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          appSize.size16.w,
                          appSize.size16.h,
                          appSize.size16.w,
                          appSize.size8.h,
                        ),
                        child: Obx(
                          () => Text(
                            controller.recordsCountLabel,
                            style: fontStyles.font12LightGrey500.copyWith(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          final records = controller.filteredRecords;
                          if (records.isEmpty) {
                            return Center(
                              child: Text(
                                "No leave records found",
                                style: fontStyles.font14LightGrey400,
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              appSize.size16.w,
                              0,
                              appSize.size16.w,
                              appSize.size24.h,
                            ),
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              return LeaveHistoryCard(record: records[index]);
                            },
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openOptionsSheet({
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
