import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_view_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_status_enum.dart';

class LeaveViewScreen extends GetView<LeaveViewController> {
  const LeaveViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(
        title: "View Leave",
        trailing: Obx(() {
          final leave = controller.leave.value;
          if (leave == null || !leave.canEdit) {
            return const SizedBox.shrink();
          }
          return IconButton(
            onPressed: controller.onEdit,
            icon: Icon(Icons.edit_outlined, color: appColors.blackColor),
          );
        }),
      ),
      body: SafeArea(
        child: Obx(() {
          return FutureBuilder(
            future: controller.leave.value == null
                ? controller.getLeave()
                : null,
            builder: (context, snapshot) {
              final leave = controller.leave.value;
              if (leave == null && !controller.hasError.value) {
                return const Center(child: LoadingScreen());
              } else if (leave != null) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    appSize.size16.w,
                    appSize.size8.h,
                    appSize.size16.w,
                    appSize.size24.h,
                  ),
                  child: Column(
                    children: [
                      _StatusCard(leave: leave),
                      SizedBox(height: appSize.size12.h),
                      _SectionCard(
                        icon: Icons.event_note_outlined,
                        title: 'Leave Information',
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            _InfoPair(
                              label: 'LEAVE TYPE',
                              valueWidget: _Chip(
                                label: leave.type.leaveType,
                                bg: controller.typeStyle(leave.type).bg,
                                text: controller.typeStyle(leave.type).text,
                              ),
                            ),
                            SizedBox(height: appSize.size12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _IconValue(
                                    icon: Icons.calendar_today_outlined,
                                    label: 'FROM DATE',
                                    value: controller.formatDate(
                                      leave.fromDate,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _IconValue(
                                    icon: Icons.event_outlined,
                                    label: 'TO DATE',
                                    value: controller.formatDate(leave.toDate),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: appSize.size12.h),
                            _InfoPair(
                              label: 'DURATION',
                              value: leave.durationLabel,
                            ),
                            SizedBox(height: appSize.size12.h),
                            _InfoPair(
                              label: 'APPLIED ON',
                              value: controller.formatDate(leave.appliedOn),
                            ),
                            if (leave.employeeName.isNotEmpty) ...[
                              SizedBox(height: appSize.size12.h),
                              _InfoPair(
                                label: 'EMPLOYEE',
                                value: leave.employeeName,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (leave.remarks.isNotEmpty)
                        _SectionCard(
                          icon: Icons.notes_rounded,
                          title: 'Remarks',
                          child: Text(
                            leave.remarks,
                            style: fontStyles.font12LightGrey500.copyWith(
                              color: appColors.blackColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                              height: 1.45,
                            ),
                          ),
                        ),
                      if (leave.hasHandover)
                        _SectionCard(
                          icon: Icons.swap_horiz_rounded,
                          title: 'Handover Details',
                          child: Column(
                            children: [
                              if (leave.handoverPersonName.isNotEmpty)
                                _InfoPair(
                                  label: 'HANDOVER PERSON',
                                  value: leave.handoverPersonName,
                                ),
                              if (leave.handoverDescription.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'HANDOVER DESCRIPTION',
                                  value: leave.handoverDescription,
                                ),
                              ],
                              if (leave.personalContact.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'PERSONAL CONTACT',
                                  value: leave.personalContact,
                                ),
                              ],
                              if (leave.emergencyContact.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'EMERGENCY CONTACT',
                                  value: leave.emergencyContact,
                                ),
                              ],
                              if (leave.travelingOutsideCountry != null) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'TRAVELING OUTSIDE COUNTRY',
                                  value: controller.yesNo(
                                    leave.travelingOutsideCountry,
                                  ),
                                ),
                              ],
                              if (leave.destination.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'DESTINATION',
                                  value: leave.destination,
                                ),
                              ],
                              if (leave.travelContact.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'TRAVEL CONTACT',
                                  value: leave.travelContact,
                                ),
                              ],
                              if (leave.declarationSigned != null) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'DECLARATION SIGNED',
                                  value: controller.yesNo(
                                    leave.declarationSigned,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      if (leave.hasExtraDetails)
                        _SectionCard(
                          icon: Icons.info_outline_rounded,
                          title: 'Additional Details',
                          child: Column(
                            children: [
                              if (leave.festivalName.isNotEmpty)
                                _InfoPair(
                                  label: 'FESTIVAL',
                                  value: leave.festivalName,
                                ),
                              if (leave.relative.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'RELATIVE',
                                  value: leave.relative,
                                ),
                              ],
                              if (leave.dueDate != null) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'DUE DATE',
                                  value: controller.formatDate(leave.dueDate!),
                                ),
                              ],
                              if (leave.childBirthDate != null) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'CHILD BIRTH DATE',
                                  value: controller.formatDate(
                                    leave.childBirthDate!,
                                  ),
                                ),
                              ],
                              if (leave.childAge.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'CHILD AGE',
                                  value: leave.childAge,
                                ),
                              ],
                            ],
                          ),
                        ),
                      if (leave.attachments.isNotEmpty)
                        _SectionCard(
                          icon: Icons.attach_file_rounded,
                          iconBg: appColors.profileIconPurpleBg,
                          iconColor: appColors.profileIconPurple,
                          title: 'Attachments',
                          child: Column(
                            children: leave.attachments
                                .map(
                                  (file) => _AttachmentRow(
                                    file: file,
                                    onView: () =>
                                        controller.onViewAttachment(file),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      if (leave.hasReview)
                        _SectionCard(
                          icon: Icons.rate_review_outlined,
                          iconBg: appColors.profileIconOrangeBg,
                          iconColor: appColors.profileIconOrange,
                          title: 'Review',
                          accentBorder: controller.statusText(leave.status),
                          child: Column(
                            children: [
                              if (leave.reviewedBy.isNotEmpty)
                                _InfoPair(
                                  label: 'REVIEWED BY',
                                  value: leave.reviewedBy,
                                ),
                              if (leave.reviewComment.isNotEmpty) ...[
                                SizedBox(height: appSize.size12.h),
                                _InfoPair(
                                  label: 'COMMENT',
                                  value: leave.reviewComment,
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                return const NoDataPage(message: "Leave details not found");
              }
            },
          );
        }),
      ),
    );
  }
}

class _StatusCard extends GetView<LeaveViewController> {
  const _StatusCard({required this.leave});

  final LeaveModel leave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: controller.statusGradient(leave.status),
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
                Text(
                  leave.status.label,
                  style: fontStyles.font20Black700Fixed.copyWith(
                    color: appColors.whiteColor,
                  ),
                ),
                SizedBox(height: appSize.size8.h),
                Text(
                  'Applied ${controller.formatDate(leave.appliedOn)}',
                  style: fontStyles.font12LightGrey500.copyWith(
                    color: appColors.whiteColor.withValues(alpha: 0.85),
                    letterSpacing: 0,
                  ),
                ),
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
              leave.status == LeaveStatus.rejected
                  ? Icons.close_rounded
                  : Icons.check_rounded,
              color: appColors.whiteColor,
              size: 22.sp,
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

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.bg, required this.text});

  final String label;
  final Color bg;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size10.w,
        vertical: appSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(appSize.radius8),
      ),
      child: Text(
        label,
        style: fontStyles.font10LightGrey500.copyWith(
          color: text,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  const _AttachmentRow({required this.file, required this.onView});

  final LeaveAttachment file;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            file.isImage ? Icons.image_outlined : Icons.picture_as_pdf_outlined,
            color: appColors.profileIconPurple,
            size: 22.sp,
          ),
          SizedBox(width: appSize.size10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name, style: fontStyles.font14Black600),
                if (file.size.isNotEmpty)
                  Text(
                    file.size,
                    style: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: onView,
            child: Text('View', style: fontStyles.font12Brand600),
          ),
        ],
      ),
    );
  }
}
