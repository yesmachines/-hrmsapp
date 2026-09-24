import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/widgets/noc_request_details_bottom_sheet.dart';

class LetterRequest {
  const LetterRequest({
    required this.title,
    required this.applyDate,
    required this.approvedDate,
    required this.status,
    this.purpose,
    this.details,
  });

  final String title;
  final String applyDate;
  final String approvedDate;
  final String status;
  final String? purpose;
  final String? details;
}

class LetterRequestsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Category'.obs;
  final RxString selectedYear = 'Year'.obs;
  final RxString selectedMonth = 'Month'.obs;
  final RxString selectedDate = 'Date'.obs;

  final RxList<LetterRequest> requests = <LetterRequest>[
    const LetterRequest(
      title: 'NOC',
      applyDate: '16 JAN 2026',
      approvedDate: '18 JAN 2026',
      status: 'Approved',
      purpose: 'Employment Visa Process',
      details:
          'Requesting a No Objection Certificate for embassy submission regarding the new employment visa renewal and international mobility transfer.',
    ),
    const LetterRequest(
      title: 'Salary Certificate',
      applyDate: '16 JAN 2026',
      approvedDate: '18 JAN 2026',
      status: 'Approved',
      purpose: 'Bank Loan Application',
      details: 'Requesting salary certificate for bank loan processing.',
    ),
    const LetterRequest(
      title: 'Salary Transfer Letter',
      applyDate: '16 JAN 2026',
      approvedDate: '18 JAN 2026',
      status: 'Approved',
      purpose: 'Salary Account Transfer',
      details: 'Requesting salary transfer letter for new bank account.',
    ),
    const LetterRequest(
      title: 'Pay Slip',
      applyDate: '16 JAN 2026',
      approvedDate: '18 JAN 2026',
      status: 'Approved',
      purpose: 'Personal Records',
      details: 'Requesting pay slip for personal documentation.',
    ),
  ].obs;

  List<LetterRequest> get filteredRequests {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return requests;
    return requests
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onViewRequest(LetterRequest request) {
    showNocRequestDetailsBottomSheet(request: request);
  }

  @override
  void dependencies() {
    Get.put(LetterRequestsController());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
