import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/assets/create_asset_request_screen/controller/controller.dart';

class RepairAssetSheet extends GetView<CreateAssetRequestController> {
  const RepairAssetSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.42,
      child: Obx(() {
        if (controller.assetsLoading.value && controller.repairAssets.isEmpty) {
          return const Center(child: LoadingScreen());
        }
        if (controller.repairAssets.isEmpty) {
          return Center(
            child: Text(
              'No assets found',
              style: fontStyles.font14LightGrey400,
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.repairAssets.length,
          itemBuilder: (context, index) {
            final asset = controller.repairAssets[index];
            final selected = asset.id == controller.selectedAsset.value?.id;
            return InkWell(
              onTap: () => controller.onAssetSelected(asset),
              borderRadius: BorderRadius.circular(appSize.radius12),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: appSize.size8.h),
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size14.w,
                  vertical: appSize.size14.h,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? appColors.submittedBadgeBg
                      : appColors.scaffoldGreyColor,
                  borderRadius: BorderRadius.circular(appSize.radius12),
                  border: Border.all(
                    color: selected
                        ? appColors.brandColor.withValues(alpha: 0.35)
                        : appColors.strokeColor,
                  ),
                ),
                child: Text(
                  controller.assetLabel(asset),
                  style: fontStyles.font14Black600.copyWith(
                    color: selected
                        ? appColors.brandColor
                        : appColors.blackColor,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
