import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/view/employee_screens/assets/asset_details_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetDetailsView extends GetView<AssetDetailsController> {
  const AssetDetailsView({super.key});

  Color _statusBg(AssetStatus status) {
    switch (status) {
      case AssetStatus.active:
        return appColors.activeBadgeBg;
      case AssetStatus.returnItem:
        return appColors.scaffoldGreyColor;
      case AssetStatus.underMaintenance:
        return appColors.expiringBadgeBg;
    }
  }

  Color _statusText(AssetStatus status) {
    switch (status) {
      case AssetStatus.active:
        return appColors.activeBadgeText;
      case AssetStatus.returnItem:
        return appColors.mediumGreyColor;
      case AssetStatus.underMaintenance:
        return appColors.expiringBadgeText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asset = controller.asset;

    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Asset Details"),
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
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: appColors.profileIconBlueBg,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                      ),
                      child: Icon(
                        asset.icon,
                        color: appColors.brandColor,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: appSize.size12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(asset.name, style: fontStyles.font14Black600),
                          SizedBox(height: 2.h),
                          Text(
                            asset.series,
                            style: fontStyles.font12LightGrey500.copyWith(
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: appSize.size10.w,
                        vertical: appSize.size4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBg(asset.status),
                        borderRadius: BorderRadius.circular(appSize.radius8),
                      ),
                      child: Text(
                        asset.status.label,
                        style: fontStyles.font10LightGrey500.copyWith(
                          color: _statusText(asset.status),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: appSize.size12.h),
              _SectionCard(
                icon: Icons.info_outline_rounded,
                title: 'Asset Information',
                child: Column(
                  children: [
                    _DetailRow(label: 'Asset Name', value: asset.name),
                    _DetailRow(
                      label: 'Asset ID / Serial Number',
                      value: asset.assetId,
                    ),
                    _DetailRow(label: 'Asset Category', value: asset.category),
                    _DetailRow(
                      label: 'Date of Assignment',
                      value: controller.formatDate(asset.assignedDate),
                    ),
                    _DetailRow(
                      label: 'Condition at Issue',
                      value: asset.condition,
                    ),
                    _DetailRow(
                      label: 'Current Status',
                      valueWidget: Text(
                        asset.status.label[0] +
                            asset.status.label.substring(1).toLowerCase(),
                        style: fontStyles.font14Black600.copyWith(
                          color: asset.status == AssetStatus.active
                              ? appColors.activeBadgeText
                              : appColors.blackColor,
                        ),
                      ),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              _SectionCard(
                icon: Icons.description_outlined,
                title: 'Acknowledgment',
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(appSize.size12.w),
                      decoration: BoxDecoration(
                        color: appColors.scaffoldGreyColor,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf_outlined,
                            color: appColors.brandColor,
                            size: 22.sp,
                          ),
                          SizedBox(width: appSize.size10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.acknowledgmentName,
                                  style: fontStyles.font14Black600,
                                ),
                                Text(
                                  asset.acknowledgmentSize,
                                  style: fontStyles.font12LightGrey500
                                      .copyWith(letterSpacing: 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: appSize.size12.h),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonName: 'View',
                            onPressed: controller.onViewAcknowledgment,
                            buttonColor: appColors.whiteColor,
                            borderColor: appColors.brandColor,
                            fontStyle: fontStyles.font14Brand700,
                          ),
                        ),
                        SizedBox(width: appSize.size10.w),
                        Expanded(
                          child: CustomButton(
                            buttonName: 'Download',
                            onPressed: controller.onDownloadAcknowledgment,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (asset.history.isNotEmpty)
                _SectionCard(
                  icon: Icons.history_rounded,
                  title: 'Asset History',
                  child: Column(
                    children: List.generate(asset.history.length, (index) {
                      final item = asset.history[index];
                      final isLast = index == asset.history.length - 1;
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: item.isPrimary
                                        ? appColors.activeBadgeText
                                        : appColors.brandColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2.w,
                                      color: appColors.strokeColor,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(width: appSize.size12.w),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: isLast ? 0 : appSize.size16.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: fontStyles.font14Black600,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      item.subtitle,
                                      style: fontStyles.font12LightGrey500
                                          .copyWith(letterSpacing: 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
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
  });

  final IconData icon;
  final String title;
  final Widget child;

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
              Icon(icon, color: appColors.brandColor, size: 18.sp),
              SizedBox(width: appSize.size8.w),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    this.value,
    this.valueWidget,
    this.showDivider = true,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: appSize.size10.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                  ),
                ),
              ),
              Flexible(
                child: valueWidget ??
                    Text(
                      value ?? '',
                      textAlign: TextAlign.right,
                      style: fontStyles.font14Black600,
                    ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: appColors.strokeColor.withValues(alpha: 0.7),
          ),
      ],
    );
  }
}
