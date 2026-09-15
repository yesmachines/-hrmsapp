import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/dashboard/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/profile/service/model/profile_model.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key, required this.profile});
  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {

    final String currentDate =
    DateFormat('EEEE, MMMM dd, yyyy')
        .format(DateTime.now())
        .toUpperCase();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: fontStyles.font14LightGrey400.copyWith(
                  color: appColors.blackColor,
                ),
              ),
              Text(
                  '${profile.name} 👋',
                  style: fontStyles.font28Black700.copyWith(fontSize: appSize.size22.sp),
                ),
              SizedBox(height: appSize.size6.h),
              Text(
                currentDate,
                  style: fontStyles.font12LightGrey500,
                ),
              SizedBox(height: appSize.size8.h),
              Text(
                'HERE IS WHAT IS HAPPENING TODAY',
                style: fontStyles.font12Brand600,
              ),
            ],
          ),
        ),
        Icon(
          Icons.work_outline_rounded,
          color: appColors.mediumGreyColor,
          size: appSize.icon24,
        ),
        SizedBox(width: appSize.size12.w),
        Badge(
          child: Icon(
            Icons.notifications_none_rounded,
            color: appColors.mediumGreyColor,
            size: appSize.icon24,
          ),
        ),
      ],
    );
  }
}
