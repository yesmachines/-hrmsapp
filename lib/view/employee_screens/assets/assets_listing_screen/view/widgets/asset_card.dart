import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetCard extends GetView<AssetsController> {
  const AssetCard({super.key, required this.asset});

  final AssetModel asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size12.h),
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
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: appColors.profileIconBlueBg,
                  borderRadius: BorderRadius.circular(appSize.radius12),
                ),
                child: Icon(asset.icon, color: appColors.brandColor, size: 22.sp),
              ),
              SizedBox(width: appSize.size12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.name, style: fontStyles.font14Black600),
                    if (asset.series.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        asset.series,
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
          SizedBox(height: appSize.size14.h),
          _InfoRow(label: 'Asset ID', value: asset.assetId),
          SizedBox(height: appSize.size8.h),
          _InfoRow(label: 'Category', value: asset.category),
          SizedBox(height: appSize.size8.h),
          _InfoRow(
            label: 'Assigned Date',
            value: controller.formatDate(asset.assignedDate),
          ),
          SizedBox(height: appSize.size8.h),
          _InfoRow(label: 'Condition', value: asset.condition),
          SizedBox(height: appSize.size14.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size10.w,
                  vertical: appSize.size4.h,
                ),
                decoration: BoxDecoration(
                  color: controller.assetStatusBg(asset.status),
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Text(
                  asset.status.label,
                  style: fontStyles.font10LightGrey500.copyWith(
                    color: controller.assetStatusText(asset.status),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => controller.onViewAsset(asset),
                borderRadius: BorderRadius.circular(appSize.radius8),
                child: Row(
                  children: [
                    Text('View', style: fontStyles.font14Brand700),
                    SizedBox(width: appSize.size4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16.sp,
                      color: appColors.brandColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AssetRequestCard extends GetView<AssetsController> {
  const AssetRequestCard({super.key, required this.request});

  final AssetRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size12.h),
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
              Expanded(
                child: Text(request.type.label, style: fontStyles.font14Black600),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size10.w,
                  vertical: appSize.size4.h,
                ),
                decoration: BoxDecoration(
                  color: controller.requestStatusBg(request.status),
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Text(
                  request.status.label,
                  style: fontStyles.font10LightGrey500.copyWith(
                    color: controller.requestStatusText(request.status),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: appSize.size14.h),
          _InfoRow(label: 'Requested Item', value: request.requestedItem),
          SizedBox(height: appSize.size8.h),
          _InfoRow(
            label: 'Request Date',
            value: controller.formatDate(request.requestDate),
          ),
          SizedBox(height: appSize.size14.h),
          Divider(height: 1, color: appColors.strokeColor),
          SizedBox(height: appSize.size12.h),
          Row(
            children: [
              Text(
                'Ticket ID: ${request.ticketId}',
                style: fontStyles.font12LightGrey500.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => controller.onViewRequest(request),
                borderRadius: BorderRadius.circular(appSize.radius8),
                child: Row(
                  children: [
                    Text('Details', style: fontStyles.font14Brand700),
                    SizedBox(width: appSize.size4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16.sp,
                      color: appColors.brandColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: fontStyles.font12LightGrey500.copyWith(letterSpacing: 0),
          ),
        ),
        Text(
          value,
          style: fontStyles.font12LightGrey500.copyWith(
            color: appColors.blackColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
