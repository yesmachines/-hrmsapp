import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/view/widgets/asset_card.dart';

class AssetsView extends GetView<AssetsController> {
  const AssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Assets"),
      floatingActionButton: Obx(() {
        if (controller.selectedTab.value != AssetsTab.requests) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: controller.onAddRequest,
          backgroundColor: appColors.brandColor,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            color: appColors.whiteColor,
            size: appSize.icon26,
          ),
        );
      }),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size8.h,
                appSize.size16.w,
                appSize.size12.h,
              ),
              child: Obx(() {
                final selected = controller.selectedTab.value;
                return Container(
                  padding: EdgeInsets.all(appSize.size4.w),
                  decoration: BoxDecoration(
                    color: appColors.whiteColor,
                    borderRadius: BorderRadius.circular(appSize.radius60),
                    border: Border.all(color: appColors.strokeColor),
                  ),
                  child: Row(
                    children: AssetsTab.values.map((tab) {
                      final isSelected = selected == tab;
                      final label = tab == AssetsTab.assets
                          ? 'Assets'
                          : 'Requests';
                      return Expanded(
                        child: InkWell(
                          onTap: () => controller.onTabChanged(tab),
                          borderRadius: BorderRadius.circular(appSize.radius60),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: appSize.size10.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.brandColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                appSize.radius60,
                              ),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: fontStyles.font12LightGrey500.copyWith(
                                color: isSelected
                                    ? appColors.whiteColor
                                    : appColors.mediumGreyColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
            Obx(() {
              final isAssetsTab =
                  controller.selectedTab.value == AssetsTab.assets;
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  appSize.size16.w,
                  0,
                  appSize.size16.w,
                  appSize.size12.h,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                        hintText: isAssetsTab
                            ? 'Search Assets...'
                            : 'Search Requests...',
                        maxLines: 1,
                        radius: appSize.radius12,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: appSize.size14.h,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.whiteColor,
                          borderRadius: BorderRadius.circular(appSize.radius12),
                          border: Border.all(color: appColors.strokeColor),
                        ),
                        prefix: Icon(
                          Icons.search_rounded,
                          color: appColors.lightGreyColor,
                          size: appSize.icon20,
                        ),
                      ),
                    ),
                    SizedBox(width: appSize.size10.w),
                    Obx(() {
                      final hasFilter = isAssetsTab
                          ? controller.selectedStatus.value != null
                          : controller.selectedRequestStatus.value != null;
                      return isAssetsTab
                          ? SizedBox.shrink()
                          : InkWell(
                              onTap: controller.onFilterTap,
                              borderRadius: BorderRadius.circular(
                                appSize.radius12,
                              ),
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: hasFilter
                                      ? appColors.submittedBadgeBg
                                      : appColors.whiteColor,
                                  borderRadius: BorderRadius.circular(
                                    appSize.radius12,
                                  ),
                                  border: Border.all(
                                    color: hasFilter
                                        ? appColors.brandColor.withValues(
                                            alpha: 0.35,
                                          )
                                        : appColors.strokeColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: hasFilter
                                      ? appColors.brandColor
                                      : appColors.blackColor,
                                  size: 20.sp,
                                ),
                              ),
                            );
                    }),
                  ],
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == AssetsTab.assets) {
                  return FutureBuilder(
                    key: ValueKey(controller.filterVersion.value),
                    future: controller.assets.value == null
                        ? controller.getAssets()
                        : null,
                    builder: (context, snapshot) {
                      if (controller.assets.value == null) {
                        return const LoadingScreen();
                      } else if (controller.assets.value!.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: controller.onRefreshAssets,
                          child: ListView.builder(
                            controller: controller.assetsScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              appSize.size16.w,
                              0,
                              appSize.size16.w,
                              appSize.size24.h,
                            ),
                            itemCount: controller.assets.value!.length,
                            itemBuilder: (context, index) {
                              return AssetCard(
                                asset: controller.assets.value![index],
                              );
                            },
                          ),
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh: controller.onRefreshAssets,
                          child: const SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: SizedBox(height: 400, child: NoDataPage()),
                          ),
                        );
                      }
                    },
                  );
                }

                return FutureBuilder(
                  key: ValueKey(controller.requestFilterVersion.value),
                  future: controller.requests.value == null
                      ? controller.getAssetRequests()
                      : null,
                  builder: (context, snapshot) {
                    if (controller.requests.value == null) {
                      return const LoadingScreen();
                    } else if (controller.requests.value!.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: controller.onRefreshRequests,
                        child: ListView.builder(
                          controller: controller.requestsScrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            appSize.size16.w,
                            0,
                            appSize.size16.w,
                            90.h,
                          ),
                          itemCount: controller.requests.value!.length,
                          itemBuilder: (context, index) {
                            return AssetRequestCard(
                              request: controller.requests.value![index],
                            );
                          },
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: controller.onRefreshRequests,
                        child: const SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(height: 400, child: NoDataPage()),
                        ),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
