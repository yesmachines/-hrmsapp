import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyContactField {
  const EmergencyContactField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class EmergencyContactController extends GetxController with Bindings {
  final RxBool isEditing = false.obs;

  final RxList<EmergencyContactField> fields = <EmergencyContactField>[
    const EmergencyContactField(
      label: 'BLOOD GROUP',
      value: 'O+',
      icon: Icons.water_drop_outlined,
    ),
    const EmergencyContactField(
      label: 'EMERGENCY CONTACT PERSON UAE',
      value: 'Fathima .K',
      icon: Icons.person_outline_rounded,
    ),
    const EmergencyContactField(
      label: 'RELATIONSHIP',
      value: 'Mother',
      icon: Icons.favorite_border_rounded,
    ),
    const EmergencyContactField(
      label: 'UAE EMERGENCY CONTACT NUMBER',
      value: '+91 875 234 7643',
      icon: Icons.phone_outlined,
    ),
    const EmergencyContactField(
      label: 'HOME COUNTRY EMERGENCY CONTACT PERSON',
      value: 'Rashid',
      icon: Icons.home_outlined,
    ),
    const EmergencyContactField(
      label: 'RELATIONSHIP',
      value: 'Father',
      icon: Icons.favorite_border_rounded,
    ),
    const EmergencyContactField(
      label: 'HOME COUNTRY EMERGENCY CONTACT NUMBER',
      value: '+91 763 982 5467',
      icon: Icons.phone_outlined,
    ),
  ].obs;

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  void saveChanges() {
    isEditing.value = false;
  }

  @override
  void dependencies() {
    Get.put(EmergencyContactController());
  }
}
