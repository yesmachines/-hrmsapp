import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/view/employee_screens/visits/visit_details_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitDetailsView extends GetView<VisitDetailsController> {
  const VisitDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final visit = controller.visit;

    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Visit Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            appSize.size24.h,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(appSize.size16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appColors.brandColor,
                      appColors.travelBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(appSize.radius16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENT STATUS',
                            style: fontStyles.font10White400.copyWith(
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: appSize.size8.h),
                          Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: appColors.checkOutGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: appSize.size8.w),
                              Text(
                                visit.status.label,
                                style: fontStyles.font20Black700Fixed.copyWith(
                                  color: appColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                          if (visit.submittedDate != null) ...[
                            SizedBox(height: appSize.size8.h),
                            Text(
                              'Submitted ${controller.formatDate(visit.submittedDate!)}',
                              style: fontStyles.font12LightGrey500.copyWith(
                                color: appColors.whiteColor.withValues(
                                  alpha: 0.85,
                                ),
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: appColors.whiteColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: appColors.whiteColor,
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: appSize.size12.h),
              _SectionCard(
                icon: Icons.calendar_month_outlined,
                title: 'Visit Information',
                child: Column(
                  children: [
                    _InfoPair(label: 'VISIT TYPE', value: visit.type.label),
                    SizedBox(height: appSize.size12.h),
                    _IconValue(
                      icon: Icons.calendar_today_outlined,
                      label: 'VISIT DATE',
                      value: controller.formatDate(visit.date),
                    ),
                    SizedBox(height: appSize.size12.h),
                    _IconValue(
                      icon: Icons.access_time_rounded,
                      label: 'EXPECTED TIME',
                      value: visit.time,
                    ),
                    SizedBox(height: appSize.size12.h),
                    _IconValue(
                      icon: Icons.location_on_outlined,
                      label: 'LOCATION',
                      value: visit.location,
                    ),
                  ],
                ),
              ),
              if (visit.visitorName != null || visit.visitorContact != null)
                _SectionCard(
                  icon: Icons.person_outline_rounded,
                  title: 'Visitor Details',
                  child: Column(
                    children: [
                      if (visit.visitorName != null)
                        _InfoPair(
                          label: 'VISITOR NAME',
                          value: visit.visitorName!,
                        ),
                      if (visit.visitorContact != null) ...[
                        SizedBox(height: appSize.size12.h),
                        _InfoPair(
                          label: 'VISITOR CONTACT',
                          value: visit.visitorContact!,
                        ),
                      ],
                    ],
                  ),
                ),
              _SectionCard(
                icon: Icons.track_changes_outlined,
                title: 'Purpose of Visit',
                child: Text(
                  visit.purposeDetail ?? visit.purpose,
                  style: fontStyles.font12LightGrey500.copyWith(
                    color: appColors.blackColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    height: 1.45,
                  ),
                ),
              ),
              if (visit.assignees.isNotEmpty)
                _SectionCard(
                  icon: Icons.groups_outlined,
                  title: 'Assigned Employees',
                  child: Column(
                    children: visit.assignees
                        .map(
                          (assignee) => Padding(
                            padding: EdgeInsets.only(bottom: appSize.size12.h),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor: appColors.profileIconBlueBg,
                                  child: Text(
                                    assignee.initials ?? assignee.name[0],
                                    style: fontStyles.font12Brand600,
                                  ),
                                ),
                                SizedBox(width: appSize.size12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        assignee.name,
                                        style: fontStyles.font14Black600,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        assignee.role,
                                        style: fontStyles.font12LightGrey500
                                            .copyWith(letterSpacing: 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (visit.approvedBy != null)
                _SectionCard(
                  icon: Icons.verified_user_outlined,
                  title: 'Approval Information',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoPair(
                        label: 'APPROVAL STATUS',
                        valueWidget: Text(
                          visit.status.label,
                          style: fontStyles.font14Black600.copyWith(
                            color: appColors.activeBadgeText,
                          ),
                        ),
                      ),
                      SizedBox(height: appSize.size12.h),
                      _InfoPair(
                        label: 'APPROVED BY',
                        value: visit.approvedBy!,
                      ),
                      if (visit.approvedDate != null) ...[
                        SizedBox(height: appSize.size12.h),
                        _InfoPair(
                          label: 'APPROVED DATE',
                          value: controller.formatDate(visit.approvedDate!),
                        ),
                      ],
                      if (visit.approvedRemarks != null) ...[
                        SizedBox(height: appSize.size12.h),
                        Text(
                          'APPROVED REMARKS',
                          style: fontStyles.font10LightGrey500.copyWith(
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: appSize.size6.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(appSize.size12.w),
                          decoration: BoxDecoration(
                            color: appColors.scaffoldGreyColor,
                            borderRadius:
                                BorderRadius.circular(appSize.radius12),
                          ),
                          child: Text(
                            '"${visit.approvedRemarks!}"',
                            style: fontStyles.font12LightGrey500.copyWith(
                              color: appColors.blackColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (visit.adminInstructions != null)
                _SectionCard(
                  icon: Icons.info_outline_rounded,
                  iconBg: appColors.expiringBadgeBg,
                  iconColor: appColors.expiringBadgeText,
                  title: 'Admin Instructions',
                  accentBorder: appColors.expiringBadgeText,
                  child: Text(
                    visit.adminInstructions!,
                    style: fontStyles.font12LightGrey500.copyWith(
                      color: appColors.blackColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      height: 1.45,
                    ),
                  ),
                ),
              if (visit.attachments.isNotEmpty)
                _SectionCard(
                  icon: Icons.attach_file_rounded,
                  iconBg: appColors.profileIconPurpleBg,
                  iconColor: appColors.profileIconPurple,
                  title: 'Attachments',
                  child: Column(
                    children: visit.attachments
                        .map(
                          (file) => Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: appSize.size8.h),
                            padding: EdgeInsets.all(appSize.size12.w),
                            decoration: BoxDecoration(
                              color: appColors.scaffoldGreyColor,
                              borderRadius:
                                  BorderRadius.circular(appSize.radius12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_outlined,
                                  color: appColors.profileIconPurple,
                                  size: 22.sp,
                                ),
                                SizedBox(width: appSize.size10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file.name,
                                        style: fontStyles.font14Black600,
                                      ),
                                      Text(
                                        file.size,
                                        style: fontStyles.font12LightGrey500
                                            .copyWith(letterSpacing: 0),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      controller.onViewAttachment(file.name),
                                  child: Text(
                                    'View',
                                    style: fontStyles.font12Brand600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
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
    this.accentBorder,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Color? iconBg;
  final Color? iconColor;
  final Color? accentBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size12.h),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius16),
        border: Border.all(color: appColors.strokeColor.withValues(alpha: 0.8)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (accentBorder != null)
              Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: accentBorder,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(appSize.radius16),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(appSize.size14.w),
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
                            borderRadius:
                                BorderRadius.circular(appSize.radius8),
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
                    SizedBox(height: appSize.size14.h),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPair extends StatelessWidget {
  const _InfoPair({
    required this.label,
    this.value,
    this.valueWidget,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: fontStyles.font10LightGrey500.copyWith(
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: appSize.size4.h),
        valueWidget ??
            Text(value ?? '', style: fontStyles.font14Black600),
      ],
    );
  }
}

class _IconValue extends StatelessWidget {
  const _IconValue({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: appColors.brandColor),
        SizedBox(width: appSize.size8.w),
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
              Text(value, style: fontStyles.font14Black600),
            ],
          ),
        ),
      ],
    );
  }
}
