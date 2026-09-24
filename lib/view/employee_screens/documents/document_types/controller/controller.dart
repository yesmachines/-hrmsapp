import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/attachment_viewer/attachment_viewer.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_category/service/model/document_category.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/model/document_file_model.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/service.dart';

class DocumentTypesController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rxn<List<DocumentFileModel>> documents = Rxn(null);
  final RxnBool hasError = RxnBool(false);

  late final String categoryCode;
  late final String categoryName;

  bool get canAddDocument => categoryCode == 'personal';

  @override
  void onInit() {
    categoryCode = categoryCodeFromArguments(Get.arguments) ?? '';
    categoryName = categoryNameFromArguments(Get.arguments);
    super.onInit();
  }

  Future<List<DocumentFileModel>> getDocuments() async {
    hasError.value = false;
    return DocumentTypesService.getDocumentFiles(categoryCode: categoryCode)
        .then((value) {
          documents.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          hasError.value = true;
          notificationHandler.apiErrorNotificationHandler(error: error);
          throw Exception();
        });
  }

  List<DocumentFileModel> get filteredDocuments {
    final files = documents.value ?? [];
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return files;
    return files
        .where(
          (file) =>
              file.displayTitle.toLowerCase().contains(query) ||
              file.documentName.toLowerCase().contains(query) ||
              file.documentNumber.toLowerCase().contains(query) ||
              file.documentCode.toLowerCase().contains(query) ||
              file.statusLabel.toLowerCase().contains(query),
        )
        .toList();
  }

  Map<String, String> documentDetails(DocumentFileModel document) {
    final details = <String, String>{};
    if (document.documentNumber.isNotEmpty) {
      details['Document Number'] = document.documentNumber;
    }
    if (document.issueDate.isNotEmpty) {
      details['Issue Date'] = document.issueDate;
    }
    if (document.expiryDate.isNotEmpty) {
      details['Expiry Date'] = document.expiryDate;
    }
    if (document.categoryName.isNotEmpty) {
      details['Category'] = document.categoryName;
    }
    return details;
  }

  IconData iconForDocument(DocumentFileModel document) {
    switch (document.documentCode) {
      case 'passport':
        return Icons.menu_book_outlined;
      case 'emirates_id':
        return Icons.badge_outlined;
      case 'visa':
        return Icons.airplane_ticket_outlined;
      case 'insurance':
        return Icons.health_and_safety_outlined;
      case 'driving_licence':
        return Icons.directions_car_outlined;
      case 'education':
        return Icons.school_outlined;
      case 'experience':
        return Icons.work_outline;
      case 'offer_letter':
      case 'employment_contracts':
      case 'confirmation_letter':
        return Icons.article_outlined;
      case 'labour_card':
        return Icons.credit_card_outlined;
      case 'warning_letter':
      case 'termination_letter':
      case 'memo':
        return Icons.gavel_outlined;
      case 'noc':
      case 'salary_certificate':
      case 'salary_transfer_letter':
      case 'pay_slip':
        return Icons.mail_outline;
      default:
        return Icons.description_outlined;
    }
  }

  Color statusBg(DocumentFileModel document) {
    switch (document.statusColor) {
      case 'green':
        return appColors.activeBadgeBg;
      case 'red':
        return appColors.rejectedBadgeBg;
      case 'blue':
        return appColors.submittedBadgeBg;
      case 'orange':
        return appColors.pendingBadgeBg;
      default:
        switch (document.status) {
          case 'approved':
            return appColors.activeBadgeBg;
          case 'rejected':
            return appColors.rejectedBadgeBg;
          default:
            return appColors.pendingBadgeBg;
        }
    }
  }

  Color statusText(DocumentFileModel document) {
    switch (document.statusColor) {
      case 'green':
        return appColors.activeBadgeText;
      case 'red':
        return appColors.rejectedBadgeText;
      case 'blue':
        return appColors.submittedBadgeText;
      case 'orange':
        return appColors.pendingBadgeText;
      default:
        switch (document.status) {
          case 'approved':
            return appColors.activeBadgeText;
          case 'rejected':
            return appColors.rejectedBadgeText;
          default:
            return appColors.pendingBadgeText;
        }
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onAddDocument() {
    if (!canAddDocument) return;
    Get.toNamed(
      appRoutes.createDocument,
      arguments: {"category_code": categoryCode},
    )?.then((value) {
      if (value == true) {
        documents.value = null;
      }
    });
  }

  void onViewDocument(DocumentFileModel document) {
    if (document.fileUrl.trim().isEmpty) {
      notificationHandler.sendNotification(
        message: 'File not available',
        notificationType: .warning,
      );
      return;
    }
    openAttachmentViewer(
      url: document.fileUrl,
      name: document.displayTitle,
    );
  }

  void onEditDocument(DocumentFileModel document) {}

  @override
  void dependencies() {
    Get.put(DocumentTypesController());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
