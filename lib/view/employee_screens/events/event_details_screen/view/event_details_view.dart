import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/events/event_details_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/events/events_listing_screen/service/model/event_model.dart';

class EventDetailsView extends GetView<EventDetailsController> {
  const EventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Event Details"),
      body: SafeArea(
        child: Obx(() {
          return FutureBuilder(
            future: controller.event.value == null
                ? controller.getEvent()
                : null,
            builder: (context, snapshot) {
              final event = controller.event.value;
              if (event == null && controller.hasError.value == false) {
                return const Center(child: LoadingScreen());
              } else if (event != null) {
                return _EventDetailsBody(event: event);
              }
              return const NoDataPage(message: 'Event not found');
            },
          );
        }),
      ),
    );
  }
}

class _EventDetailsBody extends GetView<EventDetailsController> {
  const _EventDetailsBody({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        appSize.size16.w,
        appSize.size8.h,
        appSize.size16.w,
        appSize.size24.h,
      ),
      child: Column(
        children: [
          _HeaderCard(
            event: event,
            dateHeadline: controller.dateHeadline(event),
          ),
          SizedBox(height: appSize.size12.h),
          _SectionCard(
            icon: Icons.description_outlined,
            title: 'Event Information',
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.access_time_rounded,
                  label: 'TIME',
                  value: event.time,
                ),
                if (event.venue.isNotEmpty) ...[
                  SizedBox(height: appSize.size14.h),
                  _InfoRow(
                    icon: Icons.apartment_outlined,
                    label: 'ORGANISATION',
                    value: event.venue,
                  ),
                ],
                if (event.meetingLink != null) ...[
                  SizedBox(height: appSize.size14.h),
                  _InfoRow(
                    icon: Icons.videocam_outlined,
                    label: 'MEETING LINK',
                    value: 'Join Meeting',
                    valueColor: appColors.brandColor,
                    underline: true,
                    onValueTap: controller.onJoinMeeting,
                  ),
                ],
                if (event.organizer != null) ...[
                  SizedBox(height: appSize.size14.h),
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'ORGANIZER',
                    value: event.organizer!,
                  ),
                ],
              ],
            ),
          ),
          if (event.instructions != null)
            _SectionCard(
              icon: Icons.info_outline_rounded,
              iconBg: appColors.profileIconOrangeBg,
              iconColor: appColors.profileIconOrange,
              title: 'Instructions',
              child: Text(
                event.instructions!,
                style: fontStyles.font12LightGrey500.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          if (event.meetingLink != null)
            _SectionCard(
              icon: Icons.link_rounded,
              title: 'Meeting Link',
              showDivider: false,
              child: CustomButton(
                buttonName: 'Join Meeting',
                buttonWidth: double.infinity,
                onPressed: controller.onJoinMeeting,
                prefixWidget: Padding(
                  padding: EdgeInsets.only(right: appSize.size8.w),
                  child: Icon(
                    Icons.videocam_outlined,
                    color: appColors.whiteColor,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.event, required this.dateHeadline});

  final EventModel event;
  final String dateHeadline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: event.typeLabel.toLowerCase().contains("leave")
              ? [appColors.profileIconOrange, appColors.orangeBgColor]
              : [appColors.brandColor, appColors.travelBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(appSize.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(event.type.icon, color: appColors.whiteColor, size: 16.sp),
              SizedBox(width: appSize.size8.w),
              Text(
                event.typeLabel,
                style: fontStyles.font12White500.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Text(
            event.title,
            style: fontStyles.font20Black700Fixed.copyWith(
              color: appColors.whiteColor,
            ),
          ),
          SizedBox(height: appSize.size16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  dateHeadline,
                  style: fontStyles.font12LightGrey500.copyWith(
                    color: appColors.whiteColor.withValues(alpha: 0.9),
                    letterSpacing: 0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size12.w,
                  vertical: appSize.size6.h,
                ),
                decoration: BoxDecoration(
                  color: appColors.whiteColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(appSize.radius60),
                ),
                child: Text(event.time, style: fontStyles.font12White500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.iconBg,
    this.iconColor,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Color? iconBg;
  final Color? iconColor;
  final bool showDivider;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: iconBg ?? appColors.profileIconBlueBg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? appColors.brandColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Text(title, style: fontStyles.font14Black600),
            ],
          ),
          if (showDivider) ...[
            SizedBox(height: appSize.size12.h),
            Divider(
              height: 1,
              color: appColors.strokeColor.withValues(alpha: 0.7),
            ),
            SizedBox(height: appSize.size12.h),
          ] else
            SizedBox(height: appSize.size14.h),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.underline = false,
    this.onValueTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool underline;
  final VoidCallback? onValueTap;

  @override
  Widget build(BuildContext context) {
    final valueStyle = fontStyles.font14Black600.copyWith(
      color: valueColor ?? appColors.blackColor,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: valueColor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: appColors.lightGreyColor),
        SizedBox(width: appSize.size10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: fontStyles.font10LightGrey500.copyWith(
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              onValueTap == null
                  ? Text(value, style: valueStyle)
                  : InkWell(
                      onTap: onValueTap,
                      child: Text(value, style: valueStyle),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
