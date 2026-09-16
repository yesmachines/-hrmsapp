import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/assets/create_asset_request_screen/view/widgets/repair_asset_sheet.dart';

class CreateAssetRequestController extends GetxController with Bindings {
  final TextEditingController descriptionController = TextEditingController();

  final Rx<AssetRequestType> selectedRequestType =
      AssetRequestType.newAsset.obs;
  final Rx<AssetRequestPriority> selectedPriority =
      AssetRequestPriority.normal.obs;
  final Rxn<AssetCategoryModel> selectedCategory = Rxn();
  final Rxn<AssetModel> selectedAsset = Rxn();
  final RxList<AssetCategoryModel> categories = <AssetCategoryModel>[].obs;
  final RxList<AssetModel> repairAssets = <AssetModel>[].obs;
  final RxBool categoriesLoading = false.obs;
  final RxBool assetsLoading = false.obs;

  Future<void>? _repairAssetsFuture;

  bool get isNewAsset => selectedRequestType.value == AssetRequestType.newAsset;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void onRequestTypeTap() {
    _openOptions(
      title: 'Request Type',
      options: AssetRequestType.values.map((type) => type.label).toList(),
      selected: selectedRequestType.value.label,
      onSelected: (value) {
        final type = AssetRequestType.values.firstWhere(
          (item) => item.label == value,
        );
        if (selectedRequestType.value == type) return;
        selectedRequestType.value = type;
        selectedCategory.value = null;
        selectedAsset.value = null;
        if (type == AssetRequestType.repair) {
          fetchRepairAssets();
        }
      },
    );
  }

  void onCategoryTap() {
    if (categories.isEmpty && !categoriesLoading.value) {
      fetchCategories();
    }
    customBottomSheet(
      title: 'Asset Category',
      child: Obx(() {
        if (categoriesLoading.value && categories.isEmpty) {
          return const SizedBox(height: 120, child: LoadingScreen());
        }
        if (categories.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
            child: Text(
              'No categories found',
              style: fontStyles.font14LightGrey400,
            ),
          );
        }
        return Column(
          children: categories.map((category) {
            final selected = category.id == selectedCategory.value?.id;
            return _optionTile(
              label: category.name,
              isSelected: selected,
              onTap: () {
                selectedCategory.value = category;
                Get.back();
              },
            );
          }).toList(),
        );
      }),
    );
  }

  Future<void> onAssetTap() async {
    await fetchRepairAssets();
    customBottomSheet(
      title: 'Asset',
      child: const RepairAssetSheet(),
    );
  }

  void onPriorityTap() {
    _openOptions(
      title: 'Priority',
      options: AssetRequestPriority.values.map((item) => item.label).toList(),
      selected: selectedPriority.value.label,
      onSelected: (value) {
        selectedPriority.value = AssetRequestPriority.values.firstWhere(
          (item) => item.label == value,
        );
      },
    );
  }

  void _openOptions({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    customBottomSheet(
      title: title,
      child: Column(
        children: options.map((option) {
          return _optionTile(
            label: option,
            isSelected: option == selected,
            onTap: () {
              Get.back();
              onSelected(option);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _optionTile({
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

  Future<void> fetchCategories() async {
    categoriesLoading.value = true;
    try {
      final result = await AssetsService.getAssetCategories();
      categories.assignAll(result);
    } catch (_) {
      if (categories.isEmpty) {
        notificationHandler.sendNotification(
          message: 'Unable to load categories',
          notificationType: .error,
        );
      }
    } finally {
      categoriesLoading.value = false;
    }
  }

  Future<void> fetchRepairAssets() async {
    if (repairAssets.isNotEmpty) return;
    final inFlight = _repairAssetsFuture;
    if (inFlight != null) {
      await inFlight;
      return;
    }

    final future = _loadRepairAssets();
    _repairAssetsFuture = future;
    try {
      await future;
    } finally {
      _repairAssetsFuture = null;
    }
  }

  Future<void> _loadRepairAssets() async {
    assetsLoading.value = true;
    try {
      final result = await AssetsService.getMyAssignedAssets();
      repairAssets.assignAll(result);
    } catch (_) {
      if (repairAssets.isEmpty) {
        notificationHandler.sendNotification(
          message: 'Unable to load assets',
          notificationType: .error,
        );
      }
    } finally {
      assetsLoading.value = false;
    }
  }

  String assetLabel(AssetModel asset) {
    if (asset.name.isNotEmpty &&
        asset.assetId.isNotEmpty &&
        asset.assetId != asset.id &&
        asset.assetId != asset.name) {
      return '${asset.name} (${asset.assetId})';
    }
    if (asset.name.isNotEmpty) return asset.name;
    if (asset.assetId.isNotEmpty) return asset.assetId;
    return 'Asset ${asset.id}';
  }

  void onAssetSelected(AssetModel asset) {
    selectedAsset.value = asset;
    Get.back();
  }

  String? validate() {
    if (isNewAsset && selectedCategory.value == null) {
      return 'Select asset category';
    }
    if (!isNewAsset && selectedAsset.value == null) {
      return 'Select asset';
    }
    if (descriptionController.text.trim().isEmpty) {
      return 'Enter description';
    }
    if (descriptionController.text.trim().length < 10) {
      return 'Please provide a more detailed description';
    }
    return null;
  }

  void submitRequest() {
    final error = validate();
    if (error != null) {
      notificationHandler.sendNotification(
        message: error,
        notificationType: .warning,
      );
      return;
    }

    final data = <String, dynamic>{
      "request_type": selectedRequestType.value.apiValue,
      "description": descriptionController.text.trim(),
      "priority": selectedPriority.value.apiValue,
    };
    if (isNewAsset) {
      data["category_id"] =
          int.tryParse(selectedCategory.value!.id) ??
          selectedCategory.value!.id;
    } else {
      data["asset_id"] =
          int.tryParse(selectedAsset.value!.id) ?? selectedAsset.value!.id;
    }

    loadingScreen();
    AssetsService.createAssetRequest(data: data)
        .then((value) {
          Get.back();
          Get.back(result: true);
          notificationHandler.sendNotification(
            message: 'Asset request submitted',
            notificationType: .success,
          );
        })
        .onError((error, stackTrace) {
          Get.back();
          notificationHandler.apiErrorNotificationHandler(error: error);
        });
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(CreateAssetRequestController());
  }
}
