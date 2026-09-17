import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmploymentInfoField {
  const EmploymentInfoField({
    required this.label,
    required this.value,
    required this.icon,
    this.badgeText,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? badgeText;
}

class EmploymentInformationController extends GetxController with Bindings {
  final RxList<EmploymentInfoField> fields = <EmploymentInfoField>[
    const EmploymentInfoField(
      label: 'COMPANY BELONGS',
      value: 'Acme global Holdings',
      icon: Icons.apartment_outlined,
    ),
    const EmploymentInfoField(
      label: 'DEPARTMENT',
      value: 'Development',
      icon: Icons.groups_outlined,
    ),
    const EmploymentInfoField(
      label: 'DESIGNATION',
      value: 'Senior Flutter Designer',
      icon: Icons.badge_outlined,
    ),
    const EmploymentInfoField(
      label: 'EMPLOYMENT STATUS',
      value: 'Full-time Permanent',
      icon: Icons.assignment_turned_in_outlined,
      badgeText: 'ACTIVE',
    ),
    const EmploymentInfoField(
      label: 'VISA UNIT',
      value: 'Global Mobaility South-East',
      icon: Icons.airplane_ticket_outlined,
    ),
    const EmploymentInfoField(
      label: 'UNDER VISA / WORK PERMIT',
      value: 'Tier 2 Skilled Worker Permit',
      icon: Icons.edit_document,
    ),
    const EmploymentInfoField(
      label: 'OFFICE LOCATION',
      value: 'Dubai',
      icon: Icons.location_on_outlined,
    ),
  ].obs;

  @override
  void dependencies() {
    Get.put(EmploymentInformationController());
  }
}
