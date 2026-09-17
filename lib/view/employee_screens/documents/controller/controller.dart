import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

class DocumentCategory {
  const DocumentCategory({
    required this.title,
    required this.items,
    required this.count,
    required this.accentColor,
  });

  final String title;
  final List<String> items;
  final int count;
  final Color accentColor;
}

class DocumentsController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  late final List<DocumentCategory> categories = [
    DocumentCategory(
      title: 'Employee Personal Documents',
      items: const [
        'Passport',
        'Visa',
        'Insurance',
        'Driving Licence',
        'Emirates ID',
      ],
      count: 5,
      accentColor: appColors.brandColor,
    ),
    DocumentCategory(
      title: 'Employment Documents',
      items: const [
        'Offer Letter',
        'Employment Contracts',
        'Confirmation Letter',
        'Labour Card',
      ],
      count: 4,
      accentColor: appColors.profileIconPurple,
    ),
    DocumentCategory(
      title: 'HR Documents',
      items: const ['HR Policy', 'Leave Policy', 'WFH Policy'],
      count: 3,
      accentColor: appColors.profileIconTeal,
    ),
    DocumentCategory(
      title: 'Letter Requests',
      items: const [
        'Salary Certificate',
        'Experience Letter',
        'NOC',
      ],
      count: 2,
      accentColor: appColors.orangeColor,
    ),
  ];

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
