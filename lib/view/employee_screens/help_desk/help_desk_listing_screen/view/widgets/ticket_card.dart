import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/service/model/ticket_model.dart';

class TicketCard extends GetView<HelpDeskController> {
  const TicketCard({super.key, required this.ticket});

  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: appSize.size12.h),
      child: InkWell(
        onTap: () => controller.onViewTicket(ticket),
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
                  _Chip(
                    label: ticket.category.label,
                    bg: ticket.category.bg,
                    text: ticket.category.text,
                  ),
                  const Spacer(),
                  _Chip(
                    label: ticket.status.badgeLabel,
                    bg: ticket.status.bg,
                    text: ticket.status.text,
                  ),
                ],
              ),
              SizedBox(height: appSize.size12.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.subject,
                      style: fontStyles.font16Black700,
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
              Divider(
                height: 1,
                color: appColors.strokeColor.withValues(alpha: 0.7),
              ),
              SizedBox(height: appSize.size12.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 12.sp,
                    color: appColors.lightGreyColor,
                  ),
                  SizedBox(width: appSize.size6.w),
                  Text(
                    controller.formatDate(ticket.date),
                    style: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Text('View Ticket', style: fontStyles.font14Brand700),
                  SizedBox(width: appSize.size4.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.sp,
                    color: appColors.brandColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
