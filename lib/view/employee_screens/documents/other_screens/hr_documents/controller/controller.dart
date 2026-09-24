import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../service/model/hr_document.dart';
import '../service/model/hr_document_model.dart';
import '../service/service.dart';

class HrDocumentsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Category'.obs;
  final RxString selectedYear = 'Year'.obs;
  final RxString selectedMonth = 'Month'.obs;
  final RxString selectedDate = 'Date'.obs;

  Rxn<List<HrDocumentModel>> hrDocuments = Rxn(null);
  RxnBool hasError = RxnBool(false);

  final RxList<HrDocument> documents = <HrDocument>[].obs;

  Future<List<HrDocumentModel>> getHrDocument()async{
    hasError.value = false;
    return HrDocumentService.getHrDocument()
        .then((value){
          hrDocuments.value = value;
          documents.assignAll(
            value.map(
                (hrDocuments) => HrDocument(
                    title: hrDocuments.policyName,
                    version: hrDocuments.version,
                    updatedDate: hrDocuments.updated,
                  iconColor: getDocumentIconColor(hrDocuments.documentCode),
                  iconBg: getDocumentIconBg(hrDocuments.documentCode),
                )
            )
          );
          return value;
    })
        .onError((error, stackTrace){
      hasError.value = true;
      notificationHandler.apiErrorNotificationHandler(error: error);
      throw Exception();
    });
  }
  IconData getDocumentIcon(String documentCode) {
    switch (documentCode.toLowerCase().trim()) {
      case 'hr_policy':
        return Icons.business_center_outlined;

      case 'leave_policy':
        return Icons.event_available_outlined;

      case 'wfh_policy':
        return Icons.home_work_outlined;

      default:
        return Icons.description_outlined;
    }
  }

  Color getDocumentIconColor(String documentCode) {
    switch (documentCode.toLowerCase().trim()) {
      case 'hr_policy':
        return appColors.brandColor;

      case 'leave_policy':
        return appColors.profileIconGreen;

      case 'wfh_policy':
        return appColors.orangeColor;

      default:
        return appColors.brandColor;
    }
  }

  Color getDocumentIconBg(String documentCode) {
    switch (documentCode.toLowerCase().trim()) {
      case 'hr_policy':
        return appColors.profileIconBlueBg;

      case 'leave_policy':
        return appColors.profileIconGreenBg;

      case 'wfh_policy':
        return appColors.profileIconOrangeBg;

      default:
        return appColors.profileIconBlueBg;
    }
  }


  List<HrDocument> get filteredDocuments {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return documents;
    return documents
        .where((doc) => doc.title.toLowerCase().contains(query))
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onViewDocument(HrDocument document) {}

  @override
  void dependencies() {
    Get.put(HrDocumentsController());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
