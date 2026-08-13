import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

class HrDocument {
  const HrDocument({
    required this.title,
    required this.version,
    required this.updatedDate,
    required this.iconColor,
    required this.iconBg,
  });

  final String title;
  final String version;
  final String updatedDate;
  final Color iconColor;
  final Color iconBg;
}

class HrDocumentsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Category'.obs;
  final RxString selectedYear = 'Year'.obs;
  final RxString selectedMonth = 'Month'.obs;
  final RxString selectedDate = 'Date'.obs;

  late final List<HrDocument> documents = [
    HrDocument(
      title: 'HR Policy 2026',
      version: 'Version 1.0',
      updatedDate: '15 Jan 2026',
      iconColor: appColors.brandColor,
      iconBg: appColors.profileIconBlueBg,
    ),
    HrDocument(
      title: 'Leave Policy 2026',
      version: 'Version 1.0',
      updatedDate: '27 Jan 2026',
      iconColor: appColors.profileIconGreen,
      iconBg: appColors.profileIconGreenBg,
    ),
    HrDocument(
      title: 'WFH Policy 2026',
      version: 'Version 1.0',
      updatedDate: '31 Jan 2026',
      iconColor: appColors.orangeColor,
      iconBg: appColors.profileIconOrangeBg,
    ),
  ];

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
