import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_personal_documents/view/widgets/upload_document_bottom_sheet.dart';

enum PersonalDocStatus { approved, rejected, pendingApproval }

class PersonalDocument {
  const PersonalDocument({
    required this.title,
    required this.icon,
    required this.status,
    required this.details,
  });

  final String title;
  final IconData icon;
  final PersonalDocStatus status;
  final Map<String, String> details;
}

class EmployeePersonalDocumentsController extends GetxController
    with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Category'.obs;
  final RxString selectedYear = 'Year'.obs;
  final RxString selectedMonth = 'Month'.obs;
  final RxString selectedDate = 'Date'.obs;

  final RxList<PersonalDocument> documents = <PersonalDocument>[
    PersonalDocument(
      title: 'Passport',
      icon: Icons.menu_book_outlined,
      status: PersonalDocStatus.approved,
      details: const {
        'Passport No': 'A123456789',
        'Issue Place': 'DUBAI',
        'Issue Date': '13 JULY 2026',
        'Expiry Date': '13 JAN 2026',
      },
    ),
    PersonalDocument(
      title: 'Emirates ID',
      icon: Icons.badge_outlined,
      status: PersonalDocStatus.approved,
      details: const {
        'EID No': '784-1990-1234567-1',
        'Issue Date': '13 JULY 2026',
        'Expiry Date': '13 JAN 2026',
      },
    ),
    PersonalDocument(
      title: 'Visa',
      icon: Icons.airplane_ticket_outlined,
      status: PersonalDocStatus.approved,
      details: const {
        'Visa Num': 'V987654321',
        'UID No': 'UID-2024-00123',
        'Issue date': '15 JUN 2026',
        'Expiry Date': '13 JAN 2036',
      },
    ),
    PersonalDocument(
      title: 'Insurance',
      icon: Icons.health_and_safety_outlined,
      status: PersonalDocStatus.rejected,
      details: const {
        'Company': 'STAR LIFE',
        'Number': 'INS-2024-7890',
        'Issue date': '15 JUN 2026',
        'Expiry Date': '13 JAN 2036',
      },
    ),
    PersonalDocument(
      title: 'Driving Licence',
      icon: Icons.directions_car_outlined,
      status: PersonalDocStatus.pendingApproval,
      details: const {
        'Company': 'STAR LIFE',
        'Number': 'INS-2024-7890',
        'Issue date': '15 JUN 2026',
        'Expiry Date': '13 JAN 2036',
      },
    ),
  ].obs;

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

  String statusLabel(PersonalDocStatus status) {
    switch (status) {
      case PersonalDocStatus.approved:
        return 'Approved';
      case PersonalDocStatus.rejected:
        return 'Rejected';
      case PersonalDocStatus.pendingApproval:
        return 'Pending Approval';
    }
  }

  Color statusBg(PersonalDocStatus status) {
    switch (status) {
      case PersonalDocStatus.approved:
        return appColors.activeBadgeBg;
      case PersonalDocStatus.rejected:
        return appColors.rejectedBadgeBg;
      case PersonalDocStatus.pendingApproval:
        return appColors.pendingBadgeBg;
    }
  }

  Color statusText(PersonalDocStatus status) {
    switch (status) {
      case PersonalDocStatus.approved:
        return appColors.activeBadgeText;
      case PersonalDocStatus.rejected:
        return appColors.rejectedBadgeText;
      case PersonalDocStatus.pendingApproval:
        return appColors.pendingBadgeText;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onAddDocument() {
    showUploadDocumentBottomSheet();
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
