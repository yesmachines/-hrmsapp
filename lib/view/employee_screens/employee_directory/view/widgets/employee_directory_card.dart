import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';

class EmployeeDirectoryCard extends GetView<EmployeeDirectoryController> {
  const EmployeeDirectoryCard({super.key, required this.employee});

  final EmployeeDirectoryModel employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size12.h),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(name: employee.name, avatarUrl: employee.avatarUrl),
          SizedBox(width: appSize.size12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.name, style: fontStyles.font14Black600),
                SizedBox(height: appSize.size4.h),
                Text(
                  employee.designation,
                  style: fontStyles.font12Brand600.copyWith(
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: appSize.size10.h),
                _InfoRow(
                  icon: Icons.apartment_outlined,
                  text: employee.department,
                ),
                SizedBox(height: appSize.size6.h),
                _InfoRow(
                  icon: Icons.mail_outline_rounded,
                  text: employee.email,
                ),
                SizedBox(height: appSize.size6.h),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  text: employee.phone,
                ),
              ],
            ),
          ),
          SizedBox(width: appSize.size8.w),
          CustomButton(
            buttonName: 'View',
            buttonWidth: 64.w,
            buttonHeight: 34.h,
            radius: appSize.radius8,
            padding: EdgeInsets.zero,
            fontStyle: fontStyles.font12Brand600.copyWith(
              color: appColors.whiteColor,
              letterSpacing: 0,
            ),
            onPressed: () => controller.onViewEmployee(employee),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.avatarUrl});

  final String name;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.profileIconBlueBg,
        image: avatarUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(avatarUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: avatarUrl.isEmpty
          ? Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: fontStyles.font16Black700.copyWith(
                  color: appColors.brandColor,
                ),
              ),
            )
          : null,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14.sp, color: appColors.lightGreyColor),
        SizedBox(width: appSize.size6.w),
        Expanded(
          child: Text(
            text,
            style: fontStyles.font12LightGrey500.copyWith(
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
