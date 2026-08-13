import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EducationExperienceField {
  const EducationExperienceField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class EducationExperienceController extends GetxController with Bindings {
  final RxBool isEditing = false.obs;

  final RxList<EducationExperienceField> fields = <EducationExperienceField>[
    const EducationExperienceField(
      label: 'HIGHEST EDUCATIONAL QUALIFICATION',
      value: 'Master of computer Science - University Of Sharjah',
      icon: Icons.school_outlined,
    ),
    const EducationExperienceField(
      label: 'YEARS OF EXPERIENCE',
      value: '8 Years',
      icon: Icons.work_outline_rounded,
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
    Get.put(EducationExperienceController());
  }
}
