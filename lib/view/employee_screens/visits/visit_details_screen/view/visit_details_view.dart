import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/visits/visit_details_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitDetailsView extends GetView<VisitDetailsController> {
  const VisitDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Visit Details"),
      body: SafeArea(
        child: Obx(() {
          return FutureBuilder(
            future: controller.visit.value == null
                ? controller.getVisit()
                : null,
            builder: (context, snapshot) {
              final visit = controller.visit.value;
              if (visit == null && !controller.hasError.value) {
                return const Center(child: LoadingScreen());
              } else if (visit != null) {
                return _VisitDetailsBody(visit: visit);
              }
              return const NoDataPage();
            },
          );
        }),
      ),
    );
  }
}

class _VisitDetailsBody extends GetView<VisitDetailsController> {
  const _VisitDetailsBody({required this.visit});

  final VisitModel visit;

  bool get _hasCompanyInfo =>
      (visit.company ?? '').isNotEmpty ||
      (visit.contactNo ?? '').isNotEmpty ||
      (visit.email ?? '').isNotEmpty;

  bool get _hasVisitors =>
      visit.visitors.isNotEmpty ||
      visit.visitorName != null ||
      visit.visitorContact != null;

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
          _StatusCard(visit: visit),
          SizedBox(height: appSize.size12.h),
          _SectionCard(
            icon: Icons.calendar_month_outlined,
            title: 'Visit Information',
            child: Column(
              children: [
                _IconValue(
                  icon: Icons.calendar_today_outlined,
                  label: 'START',
                  value: controller.formatDateTime(visit.startAt),
                ),
                if (visit.expectedEndDate != null) ...[
                  SizedBox(height: appSize.size12.h),
                  _IconValue(
                    icon: Icons.event_outlined,
                    label: 'END',
                    value: controller.formatDateTime(visit.expectedEndDate!),
                  ),
                ],
                if (visit.location.isNotEmpty) ...[
                  SizedBox(height: appSize.size12.h),
                  _IconValue(
                    icon: Icons.location_on_outlined,
                    label: 'LOCATION',
                    value: visit.location,
                  ),
                ],
              ],
            ),
          ),
          if (_hasCompanyInfo)
            _SectionCard(
              icon: Icons.apartment_outlined,
              title: 'Company Details',
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if ((visit.company ?? '').isNotEmpty)
                    _InfoPair(label: 'COMPANY', value: visit.company!),
                  if ((visit.contactNo ?? '').isNotEmpty) ...[
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(label: 'CONTACT NUMBER', value: visit.contactNo!),
                  ],
                  if ((visit.email ?? '').isNotEmpty) ...[
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(label: 'EMAIL', value: visit.email!),
                  ],
                ],
              ),
            ),
          if (_hasVisitors)
            _SectionCard(
              icon: Icons.person_outline_rounded,
              title: 'Visitors',
              child: visit.visitors.isNotEmpty
                  ? Column(
                      children: visit.visitors
                          .map(
                            (visitor) => _PersonRow(
                              name: visitor.name,
                              subtitle: visitor.designation,
                              initials: visitor.initials,
                            ),
                          )
                          .toList(),
                    )
                  : Column(
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
          if (visit.purpose.isNotEmpty ||
              (visit.purposeDetail ?? '').isNotEmpty)
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
          if ((visit.remarks ?? '').isNotEmpty)
            _SectionCard(
              icon: Icons.notes_rounded,
              title: 'Remarks',
              child: Text(
                visit.remarks!,
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
                      (assignee) => _PersonRow(
                        name: assignee.name,
                        subtitle: assignee.role,
                        initials:
                            assignee.initials ??
                            (assignee.name.isNotEmpty ? assignee.name[0] : '?'),
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
                  _InfoPair(label: 'APPROVED BY', value: visit.approvedBy!),
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
                        borderRadius: BorderRadius.circular(appSize.radius12),
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
                          borderRadius: BorderRadius.circular(appSize.radius12),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    file.name,
                                    style: fontStyles.font14Black600,
                                  ),
                                  if (file.size.isNotEmpty)
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
                                  controller.onViewAttachment(file),
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
    );
  }
}

class _StatusCard extends GetView<VisitDetailsController> {
  const _StatusCard({required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appColors.brandColor, appColors.travelBlue],
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
                      color: appColors.whiteColor.withValues(alpha: 0.85),
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
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.name,
    required this.subtitle,
    required this.initials,
  });

  final String name;
  final String subtitle;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appSize.size12.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: appColors.profileIconBlueBg,
            child: Text(
              initials.length > 2 ? initials.substring(0, 2) : initials,
              style: fontStyles.font12Brand600,
            ),
          ),
          SizedBox(width: appSize.size12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: fontStyles.font14Black600),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ],
            ),
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
                            borderRadius: BorderRadius.circular(
                              appSize.radius8,
                            ),
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
  const _InfoPair({required this.label, this.value, this.valueWidget});

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
        valueWidget ?? Text(value ?? '', style: fontStyles.font14Black600),
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
