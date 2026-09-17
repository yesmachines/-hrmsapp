import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/view/widgets/leave_action_tile.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/view/widgets/leave_calendar.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_screen/view/widgets/leave_event_card.dart';

class LeaveView extends GetView<LeaveController> {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(title: "Leave"),
      backgroundColor: appColors.scaffoldGreyColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            appSize.size24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomTextField(
              //   controller: controller.searchController,
              //   onChanged: controller.onSearchChanged,
              //   hintText: 'Search',
              //   maxLines: 1,
              //   radius: appSize.radius12,
              //   contentPadding: EdgeInsets.symmetric(
              //     vertical: appSize.size14.h,
              //   ),
              //   decoration: BoxDecoration(
              //     color: appColors.whiteColor,
              //     borderRadius: BorderRadius.circular(appSize.radius12),
              //     border: Border.all(color: appColors.strokeColor),
              //   ),
              //   prefix: Icon(
              //     Icons.search_rounded,
              //     color: appColors.lightGreyColor,
              //     size: appSize.icon20,
              //   ),
              // ),
              // SizedBox(height: appSize.size16.h),
              const LeaveCalendar(),
              SizedBox(height: appSize.size16.h),
              const LeaveDayDetailsCard(),
              SizedBox(height: appSize.size16.h),
              ...controller.actions.map(
                (action) => LeaveActionTile(
                  action: action,
                  onTap: () => controller.onActionTap(action),
                ),
              ),
              SizedBox(height: appSize.size20.h),
            ],
          ),
        ),
      ),
    );
  }
}
