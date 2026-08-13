import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactInfoField {
  const ContactInfoField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class ContactInformationController extends GetxController with Bindings {
  final RxBool isEditing = false.obs;

  final RxList<ContactInfoField> fields = <ContactInfoField>[
    const ContactInfoField(
      label: 'PERSONAL EMAIL',
      value: 'safwanv@gmail.com',
      icon: Icons.mail_outline_rounded,
    ),
    const ContactInfoField(
      label: 'HOME COUNTRY MOBILE NUMBER',
      value: '+91 753 987 3678',
      icon: Icons.phone_outlined,
    ),
    const ContactInfoField(
      label: 'OFFICE MOBILE NUMBER',
      value: '+91 986 342 5674',
      icon: Icons.work_outline_rounded,
    ),
    const ContactInfoField(
      label: 'UAE MOBILE NUMBER',
      value: '+91 875 234 7643',
      icon: Icons.smartphone_outlined,
    ),
    const ContactInfoField(
      label: 'UAE ADDRESS',
      value: 'Villa 42, Al Reem Island, Dubai',
      icon: Icons.location_on_outlined,
    ),
    const ContactInfoField(
      label: 'HOME COUNTRY ADDRESS',
      value: 'Villa 18, Jumeirah Village, Dubai',
      icon: Icons.home_outlined,
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
    Get.put(ContactInformationController());
  }
}
