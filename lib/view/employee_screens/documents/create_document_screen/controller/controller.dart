import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/image_picker/controller/controller.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/documents/create_document_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_category/service/model/document_category.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/model/document_type_model.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/service.dart';

class CreateDocumentController extends GetxController with Bindings {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  final RxList<DocumentTypeModel> documentTypes = <DocumentTypeModel>[].obs;
  final Rxn<DocumentTypeModel> selectedType = Rxn();
  final Rxn<DateTime> issueDate = Rxn();
  final Rxn<DateTime> expiryDate = Rxn();
  final Rxn<XFile> attachment = Rxn();
  final RxBool typesLoading = false.obs;
  String? categoryCode;
  int? documentTypeId;

  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayDateFormat = DateFormat('dd MMM yyyy');

  String get typeLabel => selectedType.value?.name ?? 'Select document type';

  String get issueDateLabel {
    final date = issueDate.value;
    if (date == null) return 'Select issue date';
    return _displayDateFormat.format(date);
  }

  String get expiryDateLabel {
    final date = expiryDate.value;
    if (date == null) return 'Select expiry date';
    return _displayDateFormat.format(date);
  }

  String get attachmentLabel => attachment.value?.name ?? 'Attach file';

  @override
  void onInit() {
    categoryCode = categoryCodeFromArguments(Get.arguments);
    final args = Get.arguments;
    if (args is Map) {
      documentTypeId =
          int.tryParse((args["document_type_id"] ?? "").toString());
    }
    fetchDocumentTypes();
    super.onInit();
  }

  Future<void> fetchDocumentTypes() async {
    typesLoading.value = true;
    try {
      final result = await DocumentTypesService.getDocumentTypes(
        categoryCode: categoryCode,
      );
      documentTypes.assignAll(result);
      if (documentTypeId != null && selectedType.value == null) {
        for (final type in result) {
          if (type.id == documentTypeId) {
            selectedType.value = type;
            if (titleController.text.trim().isEmpty) {
              titleController.text = type.name;
            }
            break;
          }
        }
      }
    } catch (_) {
      if (documentTypes.isEmpty) {
        notificationHandler.sendNotification(
          message: 'Unable to load document types',
          notificationType: .error,
        );
      }
    } finally {
      typesLoading.value = false;
    }
  }

  void onTypeTap() {
    if (documentTypes.isEmpty && !typesLoading.value) {
      fetchDocumentTypes();
    }
    customBottomSheet(
      title: 'Document Type',
      child: Obx(() {
        if (typesLoading.value && documentTypes.isEmpty) {
          return const SizedBox(height: 120, child: LoadingScreen());
        }
        if (documentTypes.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
            child: Text(
              'No document types found',
              style: fontStyles.font14LightGrey400,
            ),
          );
        }
        return Column(
          children: documentTypes.map((type) {
            final selected = selectedType.value?.id == type.id;
            return InkWell(
              onTap: () {
                final previousName = selectedType.value?.name;
                selectedType.value = type;
                if (titleController.text.trim().isEmpty ||
                    titleController.text.trim() == previousName) {
                  titleController.text = type.name;
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

  Future<void> onIssueDateTap() async {
    final now = DateTime.now();
    final picked = await _pickDate(
      initial: issueDate.value ?? now,
      firstDate: DateTime(1990),
      lastDate: expiryDate.value ?? DateTime(now.year + 30),
    );
    if (picked == null) return;
    issueDate.value = picked;
    final expiry = expiryDate.value;
    if (expiry != null && expiry.isBefore(picked)) {
      expiryDate.value = null;
    }
  }

  Future<void> onExpiryDateTap() async {
    final now = DateTime.now();
    final firstDate = issueDate.value ?? DateTime(1990);
    final picked = await _pickDate(
      initial: expiryDate.value ??
          (issueDate.value?.add(const Duration(days: 1)) ?? now),
      firstDate: firstDate,
      lastDate: DateTime(now.year + 40),
    );
    if (picked == null) return;
    expiryDate.value = picked;
  }

  Future<void> pickAttachment() async {
    await ImagePickerController.showSourceSheet(
      images: const [],
      maxAttachments: 1,
      imageQuality: 85,
      sheetTitle: 'Attachment',
      sheetSubTitle: 'Choose a file to attach',
      onChanged: (files) {
        if (files.isNotEmpty) {
          attachment.value = files.first;
        }
      },
    );
  }

  void removeAttachment() => attachment.value = null;

  Future<DateTime?> _pickDate({
    required DateTime initial,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    var initialDate = initial;
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(lastDate)) initialDate = lastDate;
    return showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.brandColor,
              onPrimary: appColors.whiteColor,
              surface: appColors.whiteColor,
              onSurface: appColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  bool get requiresNumber => selectedType.value?.requiresNumber ?? false;

  bool get requiresExpiry => selectedType.value?.requiresExpiry ?? false;

  bool get requiresAttachments =>
      selectedType.value?.requiresAttachments ?? false;

  String? _validate() {
    if (selectedType.value == null) return 'Select document type';
    if (titleController.text.trim().isEmpty) return 'Enter document title';
    if (requiresNumber && numberController.text.trim().isEmpty) {
      return 'Enter document number';
    }
    if (issueDate.value == null) return 'Select issue date';
    if (requiresExpiry && expiryDate.value == null) {
      return 'Select expiry date';
    }
    if (requiresAttachments && attachment.value == null) {
      return 'Attach a file';
    }
    return null;
  }

  void submitDocument() {
    final error = _validate();
    if (error != null) {
      notificationHandler.sendNotification(
        message: error,
        notificationType: .warning,
      );
      return;
    }

    loadingScreen();
    CreateDocumentService.createDocument(
          documentTypeId: selectedType.value!.id,
          documentTitle: titleController.text.trim(),
          documentNumber: numberController.text,
          issueDate: issueDate.value == null
              ? ''
              : _apiDateFormat.format(issueDate.value!),
          expiryDate: expiryDate.value == null
              ? ''
              : _apiDateFormat.format(expiryDate.value!),
          remarks: remarksController.text,
          file: attachment.value,
        )
        .then((value) {
          Get.back();
          Get.back(result: true);
          notificationHandler.sendNotification(
            message: 'Document created successfully',
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
    titleController.dispose();
    numberController.dispose();
    remarksController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(CreateDocumentController());
  }
}
