import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/model/event_model.dart';

class EventCard extends GetView<EventsController> {
  const EventCard({super.key, required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appSize.size12.h),
      child: InkWell(
        onTap: () => controller.onViewEvent(event),
        borderRadius: BorderRadius.circular(appSize.radius16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(appSize.size16.w),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: appColors.profileIconBlueBg,
                      borderRadius: BorderRadius.circular(appSize.radius8),
                    ),
                    child: Icon(
                      event.type.icon,
                      color: appColors.brandColor,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: appSize.size8.w),
                  Expanded(
                    child: Text(
                      event.type.badgeLabel,
                      style: fontStyles.font12Brand600.copyWith(
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: appColors.lightGreyColor,
                    size: 22.sp,
                  ),
                ],
              ),
              SizedBox(height: appSize.size12.h),
              Text(event.title, style: fontStyles.font16Black700),
              SizedBox(height: appSize.size10.h),
              Row(
                children: [
                  Expanded(
                    child: _Meta(
                      icon: Icons.access_time_rounded,
                      text: event.time,
                    ),
                  ),
                  Expanded(
                    child: _Meta(
                      icon: Icons.location_on_outlined,
                      text: event.venue,
                    ),
                  ),
                ],
              ),
              if (event.organizer != null) ...[
                SizedBox(height: appSize.size8.h),
                _Meta(
                  icon: Icons.person_outline_rounded,
                  text: event.organizer!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: appColors.lightGreyColor),
        SizedBox(width: appSize.size6.w),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: fontStyles.font12LightGrey500.copyWith(
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
