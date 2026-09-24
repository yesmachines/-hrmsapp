import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yes_hrm/main.dart';

import 'widget/calendar/event_calendar_screen.dart';
import 'widget/selected_day_events.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Event Calendar",
                style: fontStyles.font20Black700Fixed,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: appSize.size16.h),
              EventCalenderScreen(),
              SizedBox(height: appSize.size12.h),
              SelectedDayEvents(),
            ],
          ),
        ),
      ),
    );
  }
}
