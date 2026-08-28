import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/visits/visits_listing_screen/service/model/visit_model.dart';

class VisitsController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rx<VisitTab> selectedTab = VisitTab.today.obs;

  late final List<VisitModel> visits = [
    VisitModel(
      id: '1',
      type: VisitType.customerMeeting,
      status: VisitStatus.approved,
      title: 'Customer Meeting',
      date: DateTime(2026, 8, 18),
      time: '10:30 AM',
      location: 'Dubai',
      purpose: 'Client Meeting',
      assignedTask: 'Product Presentation',
      tab: VisitTab.today,
      visitorName: 'ABC Company Representative',
      visitorContact: '+91 7653 278 654',
      purposeDetail:
          'Client meeting regarding the new project. Discussion will cover scope, timeline, deliverables, and budget allocation for Q3 2026.',
      assignees: const [
        VisitAssignee(
          id: 'a1',
          name: 'Ahmed Al Rashid',
          role: 'Senior Software Engineer',
          initials: 'AA',
        ),
        VisitAssignee(
          id: 'a2',
          name: 'Sara Khan',
          role: 'Project Manager',
          initials: 'SK',
        ),
      ],
      approvedBy: 'Mohammed Hassan, HR Director',
      approvedDate: DateTime(2026, 8, 12),
      approvedRemarks:
          'Approved for client meeting. Please ensure all presentation materials are prepared.',
      adminInstructions:
          'Please carry the required documents for the meeting. Visitor parking has been arranged at Gate B. Reception will guide the visitor to Conference Room 3A.',
      attachments: const [
        VisitAttachment(name: 'Meeting_Agenda.pdf', size: '245 KB'),
      ],
      submittedDate: DateTime(2026, 8, 12),
    ),
    VisitModel(
      id: '2',
      type: VisitType.customerMeeting,
      status: VisitStatus.approved,
      title: 'Customer Meeting',
      date: DateTime(2026, 8, 18),
      time: '02:00 PM',
      location: 'Dubai',
      purpose: 'Client Meeting',
      assignedTask: 'Product Presentation',
      tab: VisitTab.today,
      purposeDetail: 'Follow-up discussion with the client team.',
      assignees: const [
        VisitAssignee(
          id: 'a2',
          name: 'Sara Khan',
          role: 'Project Manager',
          initials: 'SK',
        ),
      ],
      submittedDate: DateTime(2026, 8, 15),
    ),
    VisitModel(
      id: '3',
      type: VisitType.customerMeeting,
      status: VisitStatus.approved,
      title: 'Customer Meeting',
      date: DateTime(2026, 8, 20),
      time: '10:30 AM',
      location: 'Dubai',
      purpose: 'Client Meeting',
      assignedTask: 'Product Presentation',
      tab: VisitTab.upcoming,
      purposeDetail: 'Upcoming client presentation.',
      assignees: const [
        VisitAssignee(
          id: 'a1',
          name: 'Ahmed Al Rashid',
          role: 'Senior Software Engineer',
          initials: 'AA',
        ),
      ],
      submittedDate: DateTime(2026, 8, 16),
    ),
    VisitModel(
      id: '4',
      type: VisitType.supplierVisit,
      status: VisitStatus.approved,
      title: 'Supplier Visit',
      date: DateTime(2026, 8, 22),
      time: '11:00 AM',
      location: 'Abu Dhabi',
      purpose: 'Supplier Discussion',
      assignedTask: 'Supplier Evaluation',
      tab: VisitTab.upcoming,
      purposeDetail: 'Evaluate new supplier partnership.',
      submittedDate: DateTime(2026, 8, 17),
    ),
    VisitModel(
      id: '5',
      type: VisitType.customerMeeting,
      status: VisitStatus.completed,
      title: 'Customer Meeting',
      date: DateTime(2026, 8, 15),
      time: '10:30 AM',
      location: 'Dubai',
      purpose: 'Client Meeting',
      assignedTask: 'Product Presentation',
      tab: VisitTab.history,
      purposeDetail: 'Completed client meeting.',
      submittedDate: DateTime(2026, 8, 10),
    ),
    VisitModel(
      id: '6',
      type: VisitType.supplierVisit,
      status: VisitStatus.approved,
      title: 'Supplier Visit',
      date: DateTime(2026, 8, 10),
      time: '09:00 AM',
      location: 'Abu Dhabi',
      purpose: 'Supplier Discussion',
      assignedTask: 'Supplier Evaluation',
      tab: VisitTab.history,
      purposeDetail: 'Approved supplier visit completed.',
      submittedDate: DateTime(2026, 8, 5),
    ),
    VisitModel(
      id: '7',
      type: VisitType.customerMeeting,
      status: VisitStatus.rejected,
      title: 'Customer Meeting',
      date: DateTime(2026, 8, 8),
      time: '03:00 PM',
      location: 'Dubai',
      purpose: 'Client Meeting',
      assignedTask: 'Demo Session',
      tab: VisitTab.history,
      purposeDetail: 'Visit request was rejected.',
      submittedDate: DateTime(2026, 8, 3),
    ),
  ];

  List<VisitModel> get filteredVisits {
    final query = searchQuery.value.trim().toLowerCase();
    return visits.where((visit) {
      if (visit.tab != selectedTab.value) return false;
      if (query.isEmpty) return true;
      return visit.title.toLowerCase().contains(query) ||
          visit.type.label.toLowerCase().contains(query) ||
          visit.location.toLowerCase().contains(query) ||
          visit.purpose.toLowerCase().contains(query) ||
          visit.assignedTask.toLowerCase().contains(query);
    }).toList();
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void onTabChanged(VisitTab tab) => selectedTab.value = tab;

  void onAddVisit() => Get.toNamed(appRoutes.requestVisit);

  void onViewVisit(VisitModel visit) {
    Get.toNamed(appRoutes.visitDetails, arguments: visit);
  }

  void onFilterTap() {
    notificationHandler.sendNotification(
      message: 'Visit filters coming soon',
      notificationType: .warning,
    );
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Color statusBg(VisitStatus status) {
    switch (status) {
      case VisitStatus.approved:
        return appColors.activeBadgeBg;
      case VisitStatus.completed:
        return appColors.submittedBadgeBg;
      case VisitStatus.rejected:
        return appColors.rejectedBadgeBg;
      case VisitStatus.requested:
        return appColors.pendingBadgeBg;
    }
  }

  Color statusText(VisitStatus status) {
    switch (status) {
      case VisitStatus.approved:
        return appColors.activeBadgeText;
      case VisitStatus.completed:
        return appColors.submittedBadgeText;
      case VisitStatus.rejected:
        return appColors.rejectedBadgeText;
      case VisitStatus.requested:
        return appColors.pendingBadgeText;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(VisitsController());
  }
}
