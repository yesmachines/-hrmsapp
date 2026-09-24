import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../service/model/document_category.dart';
import '../service/model/documents_module.dart';
import '../service/service.dart';

class DocumentCategoryController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  Rxn<List<DocumentsModule>> documentsList = Rxn(null);
  RxnBool hasError = RxnBool(false);

  final RxList<DocumentCategory> categories = <DocumentCategory>[].obs;

  Future<List<DocumentsModule>> getDocuments() async{
    hasError.value = false;
    return DocumentService.getDocuments()
        .then((value){
          documentsList.value = value;

          categories.assignAll(
            value.map(
              (document) => DocumentCategory(
                title: document.categoryName,
                items: document.subcategories,
                count: document.documentCount,
                accentColor: getCategoryColor(document.shortCode),
                shortCode: document.shortCode,
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

  Color getCategoryColor(String shortCode) {
    switch (shortCode) {
      case 'personal':
        return appColors.brandColor;
      case 'employment':
        return appColors.profileIconPurple;
      case 'performance':
        return appColors.profileIconOrange;
      case 'disciplinary':
        return appColors.profileIconPink;
      case 'hr_docs':
        return appColors.profileIconTeal;
      case 'letter_requests':
        return appColors.orangeColor;
      default:
        return appColors.brandColor;
    }
  }

  List<DocumentCategory> get filteredCategories {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return categories;
    return categories
        .where(
          (category) =>
              category.title.toLowerCase().contains(query) ||
              category.items.any((item) => item.toLowerCase().contains(query)),
        )
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onCategoryTap(DocumentCategory category) {
    if (category.shortCode == 'letter_requests') {
      Get.toNamed(appRoutes.letterRequests);
      return;
    }
    Get.toNamed(
      appRoutes.documentTypes,
      arguments: {
        "category_code": category.shortCode,
        "category_name": category.title,
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
