import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/service.dart';

class LeaveBalanceItem {
  const LeaveBalanceItem({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.days,
    this.pending = 0,
  });

  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final int? days;
  final int pending;
}

Future<dynamic> showLeaveBalanceBottomSheet() {
  final year = DateTime.now().year.toString().obs;
  final loading = true.obs;
  final leaveItems = <LeaveBalanceItem>[].obs;
  final totalDays = 0.obs;

  Future<void> loadBalance() async {
    loading.value = true;
    try {
      final meta = await ApplyLeaveService.getLeaveMeta(
        year: int.tryParse(year.value),
      );
      final types = meta.leaveTypes;
      final countable = types.where((type) => type.allowBalance).toList();
      final source = countable.isNotEmpty ? countable : types;
      totalDays.value = source.fold<int>(
        0,
        (sum, type) => sum + type.balance.balance,
      );
      leaveItems.assignAll(
        types.map((type) {
          final style = _styleFor(type.leaveCode, type.leaveName);
          return LeaveBalanceItem(
            title: type.leaveName,
            icon: style.icon,
            iconBg: style.bg,
            iconColor: style.color,
            days: type.balance.balance,
            pending: type.balance.pending,
          );
        }),
      );
    } catch (_) {
      if (leaveItems.isEmpty) {
        notificationHandler.sendNotification(
          message: 'Unable to load leave balance',
          notificationType: .error,
        );
      }
    } finally {
      loading.value = false;
    }
  }

  loadBalance();

  return Get.bottomSheet(
    Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: Get.height * 0.85),
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
        child: Obx(() {
          return SingleChildScrollView(
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
                    Text(
                      'Leave Balance',
                      style: fontStyles.font20Black700Fixed,
                    ),
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
                InkWell(
                  onTap: () async {
                    await _pickYear(year);
                    loadBalance();
                  },
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
                SizedBox(height: appSize.size16.h),
                if (loading.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: LoadingScreen(),
                  )
                else ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: appSize.size16.w,
                      vertical: appSize.size20.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: appColors.profileIconBlueBg),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
                        Text(
                          '${totalDays.value} Days',
                          style: fontStyles.font24Brand700,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: appSize.size16.h),
                  if (leaveItems.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
                      child: Text(
                        'No leave balance found',
                        style: fontStyles.font14LightGrey400,
                      ),
                    )
                  else
                    ...leaveItems.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: appSize.size10.h),
                        child: _LeaveBalanceTile(item: item),
                      ),
                    ),
                ],
              ],
            ),
          );
        }),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: appColors.blackColor.withValues(alpha: 0.45),
  );
}

({IconData icon, Color bg, Color color}) _styleFor(String code, String name) {
  final raw = '${code}_$name'.toLowerCase();
  if (raw.contains('annual')) {
    return (
      icon: Icons.wb_sunny_outlined,
      bg: appColors.submittedBadgeBg,
      color: appColors.brandColor,
    );
  }
  if (raw.contains('sick')) {
    return (
      icon: Icons.medical_services_outlined,
      bg: appColors.profileIconPurpleBg,
      color: appColors.profileIconPurple,
    );
  }
  if (raw.contains('compensat')) {
    return (
      icon: Icons.workspace_premium_outlined,
      bg: appColors.profileIconGreenBg,
      color: appColors.profileIconGreen,
    );
  }
  if (raw.contains('festival')) {
    return (
      icon: Icons.celebration_outlined,
      bg: appColors.profileIconOrangeBg,
      color: appColors.profileIconOrange,
    );
  }
  if (raw.contains('compassionate')) {
    return (
      icon: Icons.favorite_outline_rounded,
      bg: appColors.profileIconPinkBg,
      color: appColors.profileIconPink,
    );
  }
  if (raw.contains('maternity')) {
    return (
      icon: Icons.child_care_outlined,
      bg: appColors.profileIconPinkBg,
      color: appColors.profileIconPink,
    );
  }
  if (raw.contains('parental')) {
    return (
      icon: Icons.family_restroom_rounded,
      bg: appColors.profileIconTealBg,
      color: appColors.profileIconTeal,
    );
  }
  if (raw.contains('unpaid')) {
    return (
      icon: Icons.money_off_rounded,
      bg: appColors.scaffoldGreyColor,
      color: appColors.mediumGreyColor,
    );
  }
  if (raw.contains('pilgrimage')) {
    return (
      icon: Icons.mosque_outlined,
      bg: appColors.profileIconGreenBg,
      color: appColors.profileIconGreen,
    );
  }
  return (
    icon: Icons.event_available_outlined,
    bg: appColors.submittedBadgeBg,
    color: appColors.brandColor,
  );
}

Future<void> _pickYear(RxString year) async {
  final current = DateTime.now().year;
  final years = List.generate(4, (index) => '${current - index}');
  await customBottomSheet(
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size14.w,
        vertical: appSize.size14.h,
      ),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius16),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: fontStyles.font14Black600),
                if (item.pending > 0) ...[
                  SizedBox(height: 2.h),
                  Text(
                    '${item.pending} pending',
                    style: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${item.days ?? 0} Days',
            style: fontStyles.font14Brand700,
          ),
        ],
      ),
    );
  }
}
