import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/model/document_type_model.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/service.dart';

import '../../letter_request_listing/service/service.dart';

class CreateLetterRequestController extends GetxController with Bindings {
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController toAddressController = TextEditingController();
  final TextEditingController visaDesignationController =
      TextEditingController();

  final RxList<DocumentTypeModel> letterTypes = <DocumentTypeModel>[].obs;
  final Rxn<DocumentTypeModel> selectedType = Rxn();
  final Rxn<DocumentTypeTemplate> selectedTemplate = Rxn();
  final RxBool typesLoading = false.obs;

  String get typeLabel => selectedType.value?.name ?? 'Select letter type';

  String get templateLabel =>
      selectedTemplate.value?.templateName ?? 'Select template';

  List<DocumentTypeTemplate> get templates =>
      selectedType.value?.templates ?? const [];

  @override
  void onInit() {
    fetchLetterTypes();
    super.onInit();
  }

  Future<void> fetchLetterTypes() async {
    typesLoading.value = true;
    try {
      final result = await DocumentTypesService.getDocumentTypes(
        categoryCode: 'letter_requests',
      );
      letterTypes.assignAll(result);
    } catch (_) {
      if (letterTypes.isEmpty) {
        notificationHandler.sendNotification(
          message: 'Unable to load letter types',
          notificationType: .error,
        );
      }
    } finally {
      typesLoading.value = false;
    }
  }

  void onTypeTap() {
    if (letterTypes.isEmpty && !typesLoading.value) {
      fetchLetterTypes();
    }
    customBottomSheet(
      title: 'Letter Type',
      child: Obx(() {
        if (typesLoading.value && letterTypes.isEmpty) {
          return const SizedBox(height: 120, child: LoadingScreen());
        }
        if (letterTypes.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
            child: Text(
              'No letter types found',
              style: fontStyles.font14LightGrey400,
            ),
          );
        }
        return Column(
          children: letterTypes.map((type) {
            final selected = selectedType.value?.id == type.id;
            return InkWell(
              onTap: () {
                selectedType.value = type;
                if (type.templates.length == 1) {
                  selectedTemplate.value = type.templates.first;
                } else {
                  selectedTemplate.value = null;
                }
                Get.back();
              },
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
                  type.name,
                  style: fontStyles.font14Black600.copyWith(
                    color: selected
                        ? appColors.brandColor
                        : appColors.blackColor,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  void onTemplateTap() {
    if (selectedType.value == null) {
      notificationHandler.sendNotification(
        message: 'Select letter type first',
        notificationType: .warning,
      );
      return;
    }
    if (templates.isEmpty) {
      notificationHandler.sendNotification(
        message: 'No templates found for this letter type',
        notificationType: .warning,
      );
      return;
    }
    customBottomSheet(
      title: 'Template',
      child: Column(
        children: templates.map((template) {
          final selected = selectedTemplate.value?.id == template.id;
          return InkWell(
            onTap: () {
              selectedTemplate.value = template;
              Get.back();
            },
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
                template.templateName,
                style: fontStyles.font14Black600.copyWith(
                  color: selected ? appColors.brandColor : appColors.blackColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String? _validate() {
    if (selectedType.value == null) return 'Select letter type';
    if (selectedTemplate.value == null) return 'Select template';
    if (purposeController.text.trim().isEmpty) return 'Enter purpose';
    if (detailsController.text.trim().isEmpty) return 'Enter details';
    if (toAddressController.text.trim().isEmpty) return 'Enter to address';
    return null;
  }

  void submitRequest() {
    final error = _validate();
    if (error != null) {
      notificationHandler.sendNotification(
        message: error,
        notificationType: .warning,
      );
      return;
    }

    loadingScreen();
    LetterRequestService.createLetterRequest(
          documentTypeId: selectedType.value!.id,
          documentTemplateId: selectedTemplate.value!.id,
          purpose: purposeController.text,
          details: detailsController.text,
          toAddress: toAddressController.text,
          visaDesignation: visaDesignationController.text,
        )
        .then((value) {
          Get.back();
          Get.back(result: true);
          notificationHandler.sendNotification(
            message: 'Letter request created successfully',
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
    purposeController.dispose();
    detailsController.dispose();
    toAddressController.dispose();
    visaDesignationController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(CreateLetterRequestController());
  }
}
