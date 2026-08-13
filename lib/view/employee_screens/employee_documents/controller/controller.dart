import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_documents/view/widgets/upload_employee_document_bottom_sheet.dart';

class EmployeeDocItem {
  const EmployeeDocItem({
    required this.title,
    required this.details,
    this.status,
    this.canEdit = false,
  });

  final String title;
  final Map<String, String> details;
  final String? status;
  final bool canEdit;
}

class EmployeeDocSection {
  const EmployeeDocSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.documents,
  });

  final String id;
  final String title;
  final IconData icon;
  final List<EmployeeDocItem> documents;
}

class EmployeeDocumentsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Category'.obs;
  final RxString selectedYear = 'Year'.obs;
  final RxString selectedMonth = 'Month'.obs;
  final RxString selectedDate = 'Date'.obs;
  final RxSet<String> expandedSections = <String>{
    'employment',
    'performance',
    'disciplinary',
  }.obs;

  final List<EmployeeDocSection> sections = [
    EmployeeDocSection(
      id: 'employment',
      title: 'Employment',
      icon: Icons.work_outline_rounded,
      documents: const [
        EmployeeDocItem(
          title: 'Offer Letter',
          details: {
            'Date of Issue': '16 JAN 2026',
            'Accepted Date': '18 JAN 2026',
          },
        ),
        EmployeeDocItem(
          title: 'Employment Contracts',
          details: {
            'Date of Issue': '23 FEB 2026',
            'Accepted Date': '26 FEB 2026',
          },
        ),
        EmployeeDocItem(
          title: 'Confirmation Letter',
          details: {
            'Date of Issue': '23 FEB 2026',
            'Accepted Date': '26 FEB 2026',
          },
        ),
        EmployeeDocItem(
          title: 'Labour Card',
          status: 'Approved',
          canEdit: true,
          details: {
            'Labour Card': 'LC-88921-00',
            'Issue Date': '26 FEB 2026',
            'Expiry Date': '29 FEB 2032',
          },
        ),
      ],
    ),
    EmployeeDocSection(
      id: 'performance',
      title: 'Performance Docs',
      icon: Icons.trending_up_rounded,
      documents: const [
        EmployeeDocItem(
          title: 'Appraisal Letter',
          details: {'Date of Issue': '16 JAN 2026'},
        ),
        EmployeeDocItem(
          title: 'Appreciation Letter',
          details: {'Date of Issue': '16 JUN 2026'},
        ),
      ],
    ),
    EmployeeDocSection(
      id: 'disciplinary',
      title: 'Disciplinary',
      icon: Icons.info_outline_rounded,
      documents: const [
        EmployeeDocItem(
          title: 'Warning Letter',
          details: {
            'Date of Issue': '28 JUL 2026',
            'Accepted Date': '30 JUL 2026',
          },
        ),
        EmployeeDocItem(
          title: 'Termination Letter',
          details: {
            'Date of Issue': '14 MAY 2026',
            'Accepted Date': '15 MAY 2026',
          },
        ),
        EmployeeDocItem(
          title: 'Memmo',
          details: {
            'Date of Issue': '12 SEP 2026',
            'Accepted Date': '15 SEP 2026',
          },
        ),
      ],
    ),
  ];

  List<EmployeeDocSection> get filteredSections {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return sections;
    return sections
        .map((section) {
          final docs = section.documents
              .where(
                (doc) =>
                    doc.title.toLowerCase().contains(query) ||
                    section.title.toLowerCase().contains(query) ||
                    doc.details.values.any(
                      (value) => value.toLowerCase().contains(query),
                    ),
              )
              .toList();
          return EmployeeDocSection(
            id: section.id,
            title: section.title,
            icon: section.icon,
            documents: docs,
          );
        })
        .where((section) => section.documents.isNotEmpty)
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void toggleSection(String sectionId) {
    if (expandedSections.contains(sectionId)) {
      expandedSections.remove(sectionId);
    } else {
      expandedSections.add(sectionId);
    }
  }

  bool isExpanded(String sectionId) => expandedSections.contains(sectionId);

  void onAddDocument() {
    showUploadEmployeeDocumentBottomSheet();
  }

  void onViewDocument(EmployeeDocItem document) {}

  void onEditDocument(EmployeeDocItem document) {}

  Color get approvedBadgeBg => appColors.activeBadgeBg;

  Color get approvedBadgeText => appColors.activeBadgeText;

  @override
  void dependencies() {
    Get.put(EmployeeDocumentsController());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
