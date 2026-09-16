import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/assets/asset_request_details_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetRequestDetailsView extends GetView<AssetRequestDetailsController> {
  const AssetRequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Request Details"),
      body: SafeArea(
        child: Obx(() {
          return FutureBuilder(
            future: controller.request.value == null
                ? controller.getAssetRequest()
                : null,
            builder: (context, snapshot) {
              final request = controller.request.value;
              if (request == null && !controller.hasError.value) {
                return const Center(child: LoadingScreen());
              } else if (request != null) {
                return _RequestDetailsBody(request: request);
              }
              return const NoDataPage(message: "Request details not found");
            },
          );
        }),
      ),
    );
  }
}

class _RequestDetailsBody extends GetView<AssetRequestDetailsController> {
  const _RequestDetailsBody({required this.request});

  final AssetRequestModel request;

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
          _StatusCard(request: request),
          SizedBox(height: appSize.size12.h),
          _SectionCard(
            icon: Icons.info_outline_rounded,
            title: 'Request Information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (request.ticketId.isNotEmpty)
                  _InfoPair(label: 'REQUEST NO', value: request.ticketId),
                SizedBox(height: appSize.size12.h),
                _InfoPair(label: 'REQUEST TYPE', value: request.type.label),
                if (request.requestedItem.isNotEmpty) ...[
                  SizedBox(height: appSize.size12.h),
                  _InfoPair(label: 'CATEGORY', value: request.requestedItem),
                ],
                if (request.assetName.isNotEmpty) ...[
                  SizedBox(height: appSize.size12.h),
                  _InfoPair(label: 'ASSET', value: request.assetName),
                ],
                SizedBox(height: appSize.size12.h),
                _InfoPair(
                  label: 'PRIORITY',
                  valueWidget: _Chip(
                    label: request.priority.label,
                    bg: request.priority == AssetRequestPriority.high
                        ? appColors.rejectedBadgeBg
                        : appColors.submittedBadgeBg,
                    text: request.priority == AssetRequestPriority.high
                        ? appColors.rejectedBadgeText
                        : appColors.submittedBadgeText,
                  ),
                ),
                SizedBox(height: appSize.size12.h),
                _InfoPair(
                  label: 'REQUESTED DATE',
                  value: controller.formatDate(request.requestDate),
                ),
              ],
            ),
          ),
          if (request.description.trim().isNotEmpty)
            _SectionCard(
              icon: Icons.notes_rounded,
              title: 'Description',
              child: Text(
                request.description,
                style: fontStyles.font12LightGrey500.copyWith(
                  color: appColors.blackColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  height: 1.45,
                ),
              ),
            ),
          if (request.requesterName.isNotEmpty)
            _SectionCard(
              icon: Icons.person_outline_rounded,
              title: 'Requester',
              child: _PersonRow(
                name: request.requesterName,
                subtitle: request.requesterDesignation,
              ),
            ),
          if (request.status == AssetRequestStatus.approved)
            _SectionCard(
              icon: Icons.verified_user_outlined,
              iconBg: appColors.activeBadgeBg,
              iconColor: appColors.activeBadgeText,
              title: 'Approval Information',
              accentBorder: appColors.activeBadgeText,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoPair(
                    label: 'STATUS',
                    valueWidget: Text(
                      request.status.label,
                      style: fontStyles.font14Black600.copyWith(
                        color: controller.statusText(request.status),
                      ),
                    ),
                  ),
                  if (request.approverName.isNotEmpty) ...[
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(label: 'APPROVED BY', value: request.approverName),
                  ],
                  if (request.approvedAt != null) ...[
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(
                      label: 'APPROVED AT',
                      value: controller.formatDateTime(request.approvedAt!),
                    ),
                  ],
                  if (request.adminNotes.trim().isNotEmpty) ...[
                    SizedBox(height: appSize.size12.h),
                    Text(
                      'ADMIN NOTES',
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
                        request.adminNotes,
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
          if (request.status == AssetRequestStatus.rejected)
            _SectionCard(
              icon: Icons.cancel_outlined,
              iconBg: appColors.rejectedBadgeBg,
              iconColor: appColors.rejectedBadgeText,
              title: 'Rejection Information',
              accentBorder: appColors.rejectedBadgeText,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoPair(
                    label: 'STATUS',
                    valueWidget: Text(
                      request.status.label,
                      style: fontStyles.font14Black600.copyWith(
                        color: controller.statusText(request.status),
                      ),
                    ),
                  ),
                  if (request.approverName.isNotEmpty) ...[
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(
                      label: 'REJECTED BY',
                      value: request.approverName,
                    ),
                  ],
                  if (request.approvedAt != null) ...[
                    SizedBox(height: appSize.size12.h),
                    _InfoPair(
                      label: 'REJECTED AT',
                      value: controller.formatDateTime(request.approvedAt!),
                    ),
                  ],
                  if (request.rejectionReason.trim().isNotEmpty) ...[
                    SizedBox(height: appSize.size12.h),
                    Text(
                      'REJECTION REASON',
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
                        color: appColors.rejectedBadgeBg,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                      ),
                      child: Text(
                        request.rejectionReason,
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
        ],
      ),
    );
  }
}

class _StatusCard extends GetView<AssetRequestDetailsController> {
  const _StatusCard({required this.request});

  final AssetRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: controller.statusGradient(request.status),
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
                  request.status.label,
                  style: fontStyles.font20Black700Fixed.copyWith(
                    color: appColors.whiteColor,
                  ),
                ),
                if (request.ticketId.isNotEmpty) ...[
                  SizedBox(height: appSize.size8.h),
                  Text(
                    request.ticketId,
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
              controller.statusIcon(request.status),
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
  const _PersonRow({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name
              .trim()
              .split(RegExp(r'\s+'))
              .where((part) => part.isNotEmpty)
              .take(2)
              .map((part) => part[0].toUpperCase())
              .join()
        : '?';
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: appColors.profileIconBlueBg,
          child: Text(initials, style: fontStyles.font12Brand600),
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
