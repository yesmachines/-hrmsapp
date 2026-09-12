import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/modal/personal_info_field.dart';


class PersonalInformationController extends GetxController with Bindings {
  final RxBool isEditing = false.obs;
  final RxString name = 'Safwan V'.obs;
  final RxString jobTitle = 'Senior Flutter Developer'.obs;
  final RxString avatarUrl = ''.obs;

  final RxList<PersonalInfoField> fields = <PersonalInfoField>[
    const PersonalInfoField(
      label: 'OFFICIAL EMAIL',
      value: 'safwanv@company.com',
      icon: Icons.mail_outline_rounded,
    ),
    const PersonalInfoField(
      label: 'EMPLOYEE ID CARD NUMBER',
      value: 'IDC -2024-0701',
      icon: Icons.badge_outlined,
    ),
    const PersonalInfoField(
      label: 'AUTO GENERATED EMPLOYEE ID',
      value: 'EMP43278',
      icon: Icons.fingerprint_rounded,
    ),
    const PersonalInfoField(
      label: 'JOIN DATE',
      value: '01 July 2001',
      icon: Icons.calendar_today_outlined,
    ),
    const PersonalInfoField(
      label: 'SALUTATION',
      value: 'Mr.',
      icon: Icons.person_outline_rounded,
    ),
    const PersonalInfoField(
      label: 'FULL NAME',
      value: 'Safwan V',
      icon: Icons.credit_card_outlined,
    ),
    const PersonalInfoField(
      label: 'GENDER',
      value: 'Male',
      icon: Icons.wc_outlined,
      isChip: true,
    ),
    const PersonalInfoField(
      label: 'DATE OF BIRTH PASSPORT',
      value: 'Aug 06, 2001',
      icon: Icons.cake_outlined,
    ),
    const PersonalInfoField(
      label: 'PERSONAL DATE OF BIRTH',
      value: 'Aug 06, 2001',
      icon: Icons.contact_page_outlined,
    ),
    const PersonalInfoField(
      label: 'MARITAL STATUS',
      value: 'Single',
      icon: Icons.favorite_border_rounded,
    ),
    const PersonalInfoField(
      label: 'NATIONALITY',
      value: 'United Kingdom',
      icon: Icons.public_outlined,
    ),
  ].obs;

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  void onChangePhoto() {}

  void saveChanges() {
    isEditing.value = false;
  }

  @override
  void dependencies() {
    Get.put(PersonalInformationController());
  }
}
