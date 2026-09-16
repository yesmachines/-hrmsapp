import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/documents/service/model/documents_module.dart';
import 'package:yes_hrm/view/employee_screens/documents/service/service.dart';

import '../service/model/document_category.dart';

class DocumentsController extends GetxController {
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
                count: int.tryParse(document.badgeText) ?? 0,
                accentColor: getCategoryColor(document.categoryName),
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

  Color getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'Employee Personal Documents':
        return appColors.brandColor;

      case 'Employment Documents':
        return appColors.profileIconPurple;

      case 'HR Documents':
        return appColors.profileIconTeal;

      case 'Letter Requests':
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
    switch (category.title) {
      case 'Employee Personal Documents':
        Get.toNamed(appRoutes.employeePersonalDocuments);
        break;
      case 'Employment Documents':
        Get.toNamed(appRoutes.employeeDocuments);
        break;
      case 'HR Documents':
        Get.toNamed(appRoutes.hrDocuments);
        break;
      case 'Letter Requests':
        Get.toNamed(appRoutes.letterRequests);
        break;
      default:
        break;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
