import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';

import '../controller/controller.dart';

class EmployeeDetailsView extends GetView<EmployeeDetailsController> {
  const EmployeeDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final employee = controller.employee;

    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Employee Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            100.h,
          ),
          child: Column(
            children: [
              Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColors.profileIconBlueBg,
                  border: Border.all(color: appColors.whiteColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.blackColor.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: employee.avatarUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(employee.avatarUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: employee.avatarUrl.isEmpty
                    ? Center(
                        child: Text(
                          employee.name.isNotEmpty
                              ? employee.name[0].toUpperCase()
                              : '?',
                          style: fontStyles.font28Black700.copyWith(
                            color: appColors.brandColor,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(height: appSize.size14.h),
              Text(employee.name, style: fontStyles.font20Black700Fixed),
              SizedBox(height: appSize.size6.h),
              Text(
                employee.designation,
                style: fontStyles.font14LightGrey400.copyWith(
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: appSize.size20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size16.w,
                  vertical: appSize.size8.h,
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
                    _DetailRow(
                      icon: Icons.apartment_outlined,
                      label: 'Department',
                      value: Text(
                        employee.departmentShort,
                        style: fontStyles.font14Black600,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    _DetailRow(
                      icon: Icons.mail_outline_rounded,
                      label: 'Email',
                      value: Text(
                        employee.email,
                        style: fontStyles.font14Black600,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    _DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Mobile',
                      value: Text(
                        employee.phone,
                        style: fontStyles.font14Black600,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    _DetailRow(
                      icon: Icons.verified_user_outlined,
                      label: 'Employee Status',
                      value: _StatusBadge(
                        label: employee.status,
                        isActive: employee.isActive,
                      ),
                    ),
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'Office Location',
                      value: Text(
                        employee.officeLocation,
                        style: fontStyles.font14Black600,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    _DetailRow(
                      icon: Icons.calendar_month_outlined,
                      label: 'Join Date',
                      value: Text(
                        employee.joinDate,
                        style: fontStyles.font14Black600,
                        textAlign: TextAlign.right,
                      ),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        buttonWidth: double.infinity,
        buttonName: 'View Full Chart',
        onPressed: controller.onViewFullChart,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final Widget value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: appSize.size14.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: appColors.profileIconBlueBg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Icon(icon, color: appColors.brandColor, size: 18.sp),
              ),
              SizedBox(width: appSize.size12.w),
              Text(
                label,
                style: fontStyles.font12LightGrey500.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: appSize.size12.w),
              Expanded(child: value),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: appColors.strokeColor.withValues(alpha: 0.7),
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bg = isActive
        ? appColors.activeBadgeBg
        : appColors.rejectedBadgeBg;
    final text = isActive
        ? appColors.activeBadgeText
        : appColors.rejectedBadgeText;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size10.w,
          vertical: appSize.size4.h,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(appSize.radius60),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(color: text, shape: BoxShape.circle),
            ),
            SizedBox(width: appSize.size6.w),
            Text(
              label,
              style: fontStyles.font10LightGrey500.copyWith(
                color: text,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
