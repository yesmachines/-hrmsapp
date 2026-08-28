import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';

class LeaveBalanceItem {
  const LeaveBalanceItem({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.days,
    this.showChevron = false,
  });

  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final int? days;
  final bool showChevron;
}

Future<dynamic> showLeaveBalanceBottomSheet({
  String initialYear = '2026',
  int totalDays = 22,
  List<LeaveBalanceItem>? items,
}) {
  final year = initialYear.obs;
  final leaveItems =
      items ??
      [
        LeaveBalanceItem(
          title: 'Annual Leave',
          icon: Icons.wb_sunny_outlined,
          iconBg: appColors.submittedBadgeBg,
          iconColor: appColors.brandColor,
          days: 22,
        ),
        LeaveBalanceItem(
          title: 'Sick Leave',
          icon: Icons.medical_services_outlined,
          iconBg: appColors.profileIconPurpleBg,
          iconColor: appColors.profileIconPurple,
          showChevron: true,
        ),
        LeaveBalanceItem(
          title: 'Compensatory Leave',
          icon: Icons.workspace_premium_outlined,
          iconBg: appColors.profileIconGreenBg,
          iconColor: appColors.profileIconGreen,
          showChevron: true,
        ),
      ];

  return Get.bottomSheet(
    Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        appSize.size16.w,
        appSize.size10.h,
        appSize.size16.w,
        appSize.size16.h,
      ),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(appSize.radius24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: appSize.size40.w,
                height: appSize.size4.h,
                decoration: BoxDecoration(
                  color: appColors.strokeColor,
                  borderRadius: BorderRadius.circular(appSize.radius60),
                ),
              ),
              SizedBox(height: appSize.size16.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text('Leave Balance', style: fontStyles.font20Black700Fixed),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: Get.back,
                      borderRadius: BorderRadius.circular(appSize.radius60),
                      child: ImageHandler(
                        imageType: ImageType.svg,
                        imageUrl: iconData.closeRoundedSvg,
                        width: appSize.icon24,
                        height: appSize.icon24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: appSize.size16.h),
              Obx(
                () => InkWell(
                  onTap: () => _pickYear(year),
                  borderRadius: BorderRadius.circular(appSize.radius60),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: appSize.size16.w,
                      vertical: appSize.size8.h,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.brandColor,
                      borderRadius: BorderRadius.circular(appSize.radius60),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: appColors.whiteColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: appSize.size6.w),
                        Text(year.value, style: fontStyles.font14White600),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: appSize.size16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size16.w,
                  vertical: appSize.size20.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.profileIconBlueBg),
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.xy(0, -1),
                    end: AlignmentGeometry.xy(0, 0),
                    colors: [appColors.lightBlue, appColors.whiteColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.blackColor.withValues(alpha: 0.09),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(appSize.radius16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: appColors.profileIconBlueBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: appColors.brandColor,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(height: appSize.size10.h),
                    Text(
                      'Total Leave Balance',
                      style: fontStyles.font12LightGrey500.copyWith(
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: appSize.size6.h),
                    Text('$totalDays Days', style: fontStyles.font24Brand700),
                  ],
                ),
              ),
              SizedBox(height: appSize.size16.h),
              ...leaveItems.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: appSize.size10.h),
                  child: _LeaveBalanceTile(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: appColors.blackColor.withValues(alpha: 0.45),
  );
}

void _pickYear(RxString year) {
  const years = ['2026', '2025', '2024'];
  customBottomSheet(
    title: 'Select Year',
    child: Column(
      children: years.map((option) {
        final selected = option == year.value;
        return InkWell(
          onTap: () {
            year.value = option;
            Get.back();
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
              color: selected
                  ? appColors.submittedBadgeBg
                  : appColors.scaffoldGreyColor,
              borderRadius: BorderRadius.circular(appSize.radius12),
              border: Border.all(
                color: selected
                    ? appColors.brandColor.withValues(alpha: 0.35)
                    : appColors.strokeColor,
              ),
            ),
            child: Text(
              option,
              style: fontStyles.font14Black600.copyWith(
                color: selected ? appColors.brandColor : appColors.blackColor,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

class _LeaveBalanceTile extends StatelessWidget {
  const _LeaveBalanceTile({required this.item});

  final LeaveBalanceItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.showChevron
          ? () {
              notificationHandler.sendNotification(
                message: '${item.title} details coming soon',
                notificationType: .warning,
              );
            }
          : null,
      borderRadius: BorderRadius.circular(appSize.radius16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius16),
          // border: Border.all(
          //   color: appColors.strokeColor.withValues(alpha: 0.8),
          // ),
          boxShadow: [
            BoxShadow(
              color: appColors.blackColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(appSize.radius12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20.sp),
            ),
            SizedBox(width: appSize.size12.w),
            Expanded(child: Text(item.title, style: fontStyles.font14Black600)),
            if (item.days != null)
              Text('${item.days} Days', style: fontStyles.font14Brand700)
            else if (item.showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: appColors.lightGreyColor,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}
