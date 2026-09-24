
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../../../document_category/service/model/document_category.dart';
import '../service/model/personal_document.dart';
import '../service/model/personal_document_model.dart';
import '../service/service.dart';


class EmployeePersonalDocumentsController extends GetxController
    with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Category'.obs;
  final RxString selectedYear = 'Year'.obs;
  final RxString selectedMonth = 'Month'.obs;
  final RxString selectedDate = 'Date'.obs;

  Rxn<List<PersonalDocumentModel>> personalDocument = Rxn(null);
  RxnBool hasError = RxnBool(false);

  final RxList<PersonalDocument> documents = <PersonalDocument>[].obs;
  late final String categoryCode;

  @override
  void onInit() {
    categoryCode =
        categoryCodeFromArguments(Get.arguments, fallback: 'personal') ??
        'personal';
    super.onInit();
  }

  Future<List<PersonalDocumentModel>> getPersonalDocument()async{
    hasError.value = false;
    return PersonalDocumentService.getPersonalDocument(
      categoryCode: categoryCode,
    )
        .then((value){
          personalDocument.value = value;
          documents.assignAll(
            value.map(
                  (personalDocument) => PersonalDocument(
                title: personalDocument.documentName,
                icon: getDocumentIcon(
                  personalDocument.documentName,
                ),
                status: null,
                details: {
                  'Category': personalDocument.categoryName,
                  'Document Code': personalDocument.documentCode,
                },
              ),
            ),
          );
          return value;
    })
        .onError((error, stackTrace){
      hasError.value = true;
      notificationHandler.apiErrorNotificationHandler(error: error);
      throw Exception();
    });
  }

  IconData getDocumentIcon(String documentName) {
    switch (documentName.toLowerCase()) {
      case 'passport':
        return Icons.menu_book_outlined;

      case 'emirates id':
        return Icons.badge_outlined;

      case 'visa':
        return Icons.airplane_ticket_outlined;

      case 'insurance':
        return Icons.health_and_safety_outlined;

      case 'driving licence':
        return Icons.directions_car_outlined;

      case 'appraisal letter':
        return Icons.description_outlined;

      case 'appreciation letter':
        return Icons.workspace_premium_outlined;

      default:
        return Icons.description_outlined;
    }
  }

  // final RxList<PersonalDocument> documents = <PersonalDocument>[
  //   PersonalDocument(
  //     title: 'Passport',
  //     icon: Icons.menu_book_outlined,
  //     status: PersonalDocStatus.approved,
  //     details: const {
  //       'Passport No': 'A123456789',
  //       'Issue Place': 'DUBAI',
  //       'Issue Date': '13 JULY 2026',
  //       'Expiry Date': '13 JAN 2026',
  //     },
  //   ),
  //   PersonalDocument(
  //     title: 'Emirates ID',
  //     icon: Icons.badge_outlined,
  //     status: PersonalDocStatus.approved,
  //     details: const {
  //       'EID No': '784-1990-1234567-1',
  //       'Issue Date': '13 JULY 2026',
  //       'Expiry Date': '13 JAN 2026',
  //     },
  //   ),
  // ].obs;

  List<PersonalDocument> get filteredDocuments {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return documents;
    return documents
        .where(
          (doc) =>
              doc.title.toLowerCase().contains(query) ||
              doc.details.values.any(
                (value) => value.toLowerCase().contains(query),
              ),
        )
        .toList();
  }

  String statusLabel(PersonalDocStatus? status) {
    switch (status) {
      case PersonalDocStatus.approved:
        return 'Approved';
      case PersonalDocStatus.rejected:
        return 'Rejected';
      case PersonalDocStatus.pendingApproval:
        return 'Pending Approval';
      case null:
        return '';
    }
  }

  Color statusBg(PersonalDocStatus? status) {
    switch (status) {
      case PersonalDocStatus.approved:
        return appColors.activeBadgeBg;
      case PersonalDocStatus.rejected:
        return appColors.rejectedBadgeBg;
      case PersonalDocStatus.pendingApproval:
        return appColors.pendingBadgeBg;
      case null:
        return Colors.transparent;
    }
  }

  Color statusText(PersonalDocStatus? status) {
    switch (status) {
      case PersonalDocStatus.approved:
        return appColors.activeBadgeText;
      case PersonalDocStatus.rejected:
        return appColors.rejectedBadgeText;
      case PersonalDocStatus.pendingApproval:
        return appColors.pendingBadgeText;
      case null:
        return appColors.lightGreyColor;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onAddDocument() {
    Get.toNamed(
      appRoutes.createDocument,
      arguments: {"category_code": categoryCode},
    )?.then((value) {
      if (value == true) {
        personalDocument.value = null;
      }
    });
  }

  void onViewDocument(PersonalDocument document) {}

  void onEditDocument(PersonalDocument document) {}

  @override
  void dependencies() {
    Get.put(EmployeePersonalDocumentsController());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
