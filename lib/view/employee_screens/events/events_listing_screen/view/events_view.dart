import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/view/widgets/event_card.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Events"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size8.h,
                appSize.size16.w,
                appSize.size12.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Events Today', style: fontStyles.font20Black700Fixed),
                  SizedBox(height: appSize.size8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14.sp,
                        color: appColors.brandColor,
                      ),
                      SizedBox(width: appSize.size8.w),
                      Text(
                        controller.todayLabel,
                        style: fontStyles.font12LightGrey500.copyWith(
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: appSize.size8.h),
                  Text(
                    "Today's Activities",
                    style: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.events.isEmpty
                  ? const NoDataPage()
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        appSize.size16.w,
                        0,
                        appSize.size16.w,
                        appSize.size24.h,
                      ),
                      itemCount: controller.events.length,
                      itemBuilder: (context, index) {
                        return EventCard(event: controller.events[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
