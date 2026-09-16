import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/service.dart';

class AssetsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final ScrollController assetsScrollController = ScrollController();
  final ScrollController requestsScrollController = ScrollController();
  final RxString searchQuery = ''.obs;
  final Rx<AssetsTab> selectedTab = AssetsTab.assets.obs;
  final Rxn<AssetStatus> selectedStatus = Rxn();
  final Rxn<AssetRequestStatus> selectedRequestStatus = Rxn();
  final Rxn<List<AssetModel>> assets = Rxn(null);
  final Rxn<List<AssetRequestModel>> requests = Rxn(null);

  int assetsPage = 1;
  int assetsLastPage = 1;
  int requestsPage = 1;
  int requestsLastPage = 1;
  int _assetsFetchId = 0;
  int _requestsFetchId = 0;
  final RxInt filterVersion = 0.obs;
  final RxInt requestFilterVersion = 0.obs;
  Timer? _searchDebounce;

  @override
  void onInit() {
    assetsScrollController.addListener(() {
      if (assetsScrollController.position.extentAfter == 0 &&
          assetsPage <= assetsLastPage &&
          assetsPage != assetsLastPage) {
        assetsPage++;
        getAssets();
      }
    });
    requestsScrollController.addListener(() {
      if (requestsScrollController.position.extentAfter == 0 &&
          requestsPage <= requestsLastPage &&
          requestsPage != requestsLastPage) {
        requestsPage++;
        getAssetRequests();
      }
    });
    super.onInit();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), applyFilters);
  }

  void onTabChanged(AssetsTab tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
  }

  void applyFilters() {
    if (selectedTab.value == AssetsTab.assets) {
      onRefreshAssets();
    } else {
      onRefreshRequests();
    }
  }

  void onFilterTap() {
    if (selectedTab.value == AssetsTab.assets) {
      _openAssetStatusFilter();
    } else {
      _openRequestStatusFilter();
    }
  }

  void _openAssetStatusFilter() {
    customBottomSheet(
      title: 'Status',
      child: Column(
        children: [
          _statusOption(
            label: 'All',
            isSelected: selectedStatus.value == null,
            onTap: () {
              selectedStatus.value = null;
              Get.back();
              applyFilters();
            },
          ),
          ...AssetStatus.values.map((status) {
            return _statusOption(
              label: status.label,
              isSelected: selectedStatus.value == status,
              onTap: () {
                selectedStatus.value = status;
                Get.back();
                applyFilters();
              },
            );
          }),
        ],
      ),
    );
  }

  void _openRequestStatusFilter() {
    customBottomSheet(
      title: 'Status',
      child: Column(
        children: [
          _statusOption(
            label: 'All',
            isSelected: selectedRequestStatus.value == null,
            onTap: () {
              selectedRequestStatus.value = null;
              Get.back();
              applyFilters();
            },
          ),
          ...AssetRequestStatus.values.map((status) {
            return _statusOption(
              label: status.label,
              isSelected: selectedRequestStatus.value == status,
              onTap: () {
                selectedRequestStatus.value = status;
                Get.back();
                applyFilters();
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _statusOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: appSize.size8.h),
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.submittedBadgeBg
              : appColors.scaffoldGreyColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(
            color: isSelected
                ? appColors.brandColor.withValues(alpha: 0.35)
                : appColors.strokeColor,
          ),
        ),
        child: Text(
          label,
          style: fontStyles.font14Black600.copyWith(
            color: isSelected ? appColors.brandColor : appColors.blackColor,
          ),
        ),
      ),
    );
  }

  void onAddRequest() {
    Get.toNamed(appRoutes.createAssetRequest)?.then((value) {
      if (value == true) onRefreshRequests();
    });
  }

  void onViewAsset(AssetModel asset) {
    Get.toNamed(appRoutes.assetDetails, arguments: asset);
  }

  void onViewRequest(AssetRequestModel request) {
    Get.toNamed(appRoutes.assetRequestDetails, arguments: request.id);
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Color assetStatusBg(AssetStatus status) {
    switch (status) {
      case AssetStatus.active:
        return appColors.activeBadgeBg;
      case AssetStatus.returnItem:
        return appColors.scaffoldGreyColor;
      case AssetStatus.underMaintenance:
        return appColors.expiringBadgeBg;
    }
  }

  Color assetStatusText(AssetStatus status) {
    switch (status) {
      case AssetStatus.active:
        return appColors.activeBadgeText;
      case AssetStatus.returnItem:
        return appColors.mediumGreyColor;
      case AssetStatus.underMaintenance:
        return appColors.expiringBadgeText;
    }
  }

  Color requestStatusBg(AssetRequestStatus status) {
    switch (status) {
      case AssetRequestStatus.pending:
        return appColors.pendingBadgeBg;
      case AssetRequestStatus.approved:
        return appColors.activeBadgeBg;
      case AssetRequestStatus.completed:
        return appColors.submittedBadgeBg;
      case AssetRequestStatus.rejected:
        return appColors.rejectedBadgeBg;
    }
  }

  Color requestStatusText(AssetRequestStatus status) {
    switch (status) {
      case AssetRequestStatus.pending:
        return appColors.pendingBadgeText;
      case AssetRequestStatus.approved:
        return appColors.activeBadgeText;
      case AssetRequestStatus.completed:
        return appColors.submittedBadgeText;
      case AssetRequestStatus.rejected:
        return appColors.rejectedBadgeText;
    }
  }

  Future<void> onRefreshAssets() async {
    assetsPage = 1;
    assetsLastPage = 1;
    assets.value = null;
    filterVersion.value++;
  }

  Future<void> onRefreshRequests() async {
    requestsPage = 1;
    requestsLastPage = 1;
    requests.value = null;
    requestFilterVersion.value++;
  }

  Future<List<AssetModel>> getAssets() async {
    final fetchId = ++_assetsFetchId;
    return AssetsService.getAssets(
          page: assetsPage,
          search: searchQuery.value,
          status: selectedStatus.value,
        )
        .then((value) {
          if (fetchId != _assetsFetchId) return value.assets;
          assetsPage = value.pagination.currentPage;
          assetsLastPage = value.pagination.lastPage;
          if (assets.value == null) {
            assets.value = value.assets;
          } else {
            assets.value = [...assets.value!, ...value.assets];
          }
          return value.assets;
        })
        .onError((error, stackTrace) {
          if (fetchId != _assetsFetchId) throw Exception("");
          if (assets.value == null) {
            assets.value = [];
          }
          throw Exception("");
        });
  }

  Future<List<AssetRequestModel>> getAssetRequests() async {
    final fetchId = ++_requestsFetchId;
    return AssetsService.getAssetRequests(
          page: requestsPage,
          search: searchQuery.value,
          status: selectedRequestStatus.value,
        )
        .then((value) {
          if (fetchId != _requestsFetchId) return value.requests;
          requestsPage = value.pagination.currentPage;
          requestsLastPage = value.pagination.lastPage;
          if (requests.value == null) {
            requests.value = value.requests;
          } else {
            requests.value = [...requests.value!, ...value.requests];
          }
          return value.requests;
        })
        .onError((error, stackTrace) {
          if (fetchId != _requestsFetchId) throw Exception("");
          if (requests.value == null) {
            requests.value = [];
          }
          throw Exception("");
        });
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    assetsScrollController.dispose();
    requestsScrollController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(AssetsController());
  }
}
