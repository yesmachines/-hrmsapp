import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class CreateAssetRequestController extends GetxController with Bindings {
  final TextEditingController reasonController = TextEditingController();

  final requestTypes = AssetRequestType.values.map((e) => e.label).toList();
  final categories = const [
    'Laptop',
    'Mobile Devices',
    'Headphone',
    'Access Card',
    'Monitor',
  ];

  final RxString selectedRequestType =
      AssetRequestType.newAsset.label.obs;
  final RxnString selectedCategory = RxnString();

  void onRequestTypeTap() {
    _openOptions(
      title: 'Request Type',
      options: requestTypes,
      selected: selectedRequestType.value,
      onSelected: (value) => selectedRequestType.value = value,
    );
  }

  void onCategoryTap() {
    _openOptions(
      title: 'Asset Category',
      options: categories,
      selected: selectedCategory.value,
      onSelected: (value) => selectedCategory.value = value,
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
          final isSelected = option == selected;
          return InkWell(
            onTap: () {
              Get.back();
              onSelected(option);
            },
            borderRadius: BorderRadius.circular(appSize.radius12),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: appSize.size8),
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size14,
                vertical: appSize.size14,
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
                option,
                style: fontStyles.font14Black600.copyWith(
                  color: isSelected
                      ? appColors.brandColor
                      : appColors.blackColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String? validate() {
    if (selectedRequestType.value.trim().isEmpty) {
      return 'Select request type';
    }
    if (selectedCategory.value == null ||
        selectedCategory.value!.trim().isEmpty) {
      return 'Select asset category';
    }
    if (reasonController.text.trim().isEmpty) {
      return 'Enter reason / description';
    }
    if (reasonController.text.trim().length < 10) {
      return 'Please provide a more detailed reason';
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

    loadingScreen();
    Future.delayed(const Duration(milliseconds: 700), () {
      Get.back();
      Get.back(result: true);
      notificationHandler.sendNotification(
        message: 'Asset request submitted',
        notificationType: .success,
      );
    });
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(CreateAssetRequestController());
  }
}
