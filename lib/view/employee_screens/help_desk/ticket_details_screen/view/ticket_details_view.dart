import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/service/model/ticket_model.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/ticket_details_screen/controller/controller.dart';

class TicketDetailsView extends GetView<TicketDetailsController> {
  const TicketDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ticket = controller.ticket;

    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Ticket Details"),
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
              _StatusCard(ticket: ticket),
              SizedBox(height: appSize.size12.h),
              _SectionCard(
                icon: Icons.confirmation_number_outlined,
                title: 'Ticket Information',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoPair(
                      label: 'TICKET CATEGORY',
                      value: ticket.category.fullLabel,
                    ),
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(label: 'SUBJECT', value: ticket.subject),
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(
                      label: 'DESCRIPTION',
                      value: ticket.description,
                    ),
                  ],
                ),
              ),
              if (ticket.attachments.isNotEmpty)
                _SectionCard(
                  icon: Icons.attach_file_rounded,
                  iconBg: appColors.profileIconPurpleBg,
                  iconColor: appColors.profileIconPurple,
                  title: 'Attachments',
                  child: Column(
                    children: ticket.attachments
                        .map(
                          (file) => _AttachmentRow(
                            file: file,
                            onView: () => controller.onViewAttachment(file),
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (ticket.comments.isNotEmpty)
                _SectionCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconBg: appColors.profileIconOrangeBg,
                  iconColor: appColors.profileIconOrange,
                  title: 'Comments & Replies',
                  child: Column(
                    children: ticket.comments
                        .map((comment) => _CommentTile(comment: comment))
                        .toList(),
                  ),
                ),
              _SectionCard(
                icon: Icons.sync_rounded,
                title: 'Ticket Status',
                child: _StatusTimeline(ticket: ticket),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends GetView<TicketDetailsController> {
  const _StatusCard({required this.ticket});

  final TicketModel ticket;

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
                        color: ticket.status.indicator,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: appSize.size8.w),
                    Text(
                      ticket.status.label,
                      style: fontStyles.font20Black700Fixed.copyWith(
                        color: appColors.whiteColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appSize.size8.h),
                Text(
                  'Submitted on ${controller.formatDate(ticket.submittedDate)}  •  Ticket #${ticket.ticketNumber}',
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
              Icons.headset_mic_outlined,
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
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Color? iconBg;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size12.h),
      padding: EdgeInsets.all(appSize.size14.w),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius16),
        border: Border.all(color: appColors.strokeColor.withValues(alpha: 0.8)),
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
          SizedBox(height: appSize.size14.h),
          child,
        ],
      ),
    );
  }
}

class _InfoPair extends StatelessWidget {
  const _InfoPair({required this.label, required this.value});

  final String label;
  final String value;

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
        Text(
          value,
          style: fontStyles.font14Black600.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  const _AttachmentRow({required this.file, required this.onView});

  final TicketAttachment file;
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
            file.type.icon,
            color: appColors.profileIconPurple,
            size: 22.sp,
          ),
          SizedBox(width: appSize.size10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name, style: fontStyles.font14Black600),
                Text(
                  '${file.type.label} - ${file.size}',
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

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final TicketComment comment;

  @override
  Widget build(BuildContext context) {
    final isSupport = comment.authorType == TicketAuthorType.support;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size10.h),
      decoration: BoxDecoration(
        color: appColors.scaffoldGreyColor,
        borderRadius: BorderRadius.circular(appSize.radius12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: appColors.brandColor,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(appSize.radius12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(appSize.size12.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: isSupport
                          ? appColors.profileIconBlueBg
                          : appColors.whiteColor,
                      child: Text(
                        comment.avatarLabel,
                        style: fontStyles.font10LightGrey500.copyWith(
                          color: isSupport
                              ? appColors.brandColor
                              : appColors.mediumGreyColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    SizedBox(width: appSize.size10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSupport ? 'Support Team' : 'You',
                            style: fontStyles.font14Black600,
                          ),
                          SizedBox(height: appSize.size4.h),
                          Text(
                            comment.message,
                            style: fontStyles.font12LightGrey500.copyWith(
                              letterSpacing: 0,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _StatusTimeline extends GetView<TicketDetailsController> {
  const _StatusTimeline({required this.ticket});

  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    final steps = TicketStatus.values;
    final currentIndex = ticket.status.stepIndex;

    return Column(
      children: List.generate(steps.length, (index) {
        final status = steps[index];
        final isLast = index == steps.length - 1;
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _TimelineDot(isCompleted: isCompleted, isCurrent: isCurrent),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.w,
                        color: isCompleted
                            ? appColors.checkOutGreen
                            : appColors.strokeColor,
                      ),
                    ),
                ],
              ),
              SizedBox(width: appSize.size12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : appSize.size16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.label,
                        style: fontStyles.font14Black600.copyWith(
                          color: isCurrent
                              ? appColors.brandColor
                              : appColors.blackColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        controller.timelineDescription(status),
                        style: fontStyles.font12LightGrey500.copyWith(
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.isCompleted, required this.isCurrent});

  final bool isCompleted;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return Container(
        width: 18.w,
        height: 18.w,
        decoration: BoxDecoration(
          color: appColors.brandColor,
          shape: BoxShape.circle,
        ),
      );
    }
    if (isCompleted) {
      return Container(
        width: 18.w,
        height: 18.w,
        decoration: BoxDecoration(
          color: appColors.checkOutGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_rounded,
          size: 12.sp,
          color: appColors.whiteColor,
        ),
      );
    }
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: appColors.strokeColor, width: 2),
        color: appColors.whiteColor,
      ),
    );
  }
}
