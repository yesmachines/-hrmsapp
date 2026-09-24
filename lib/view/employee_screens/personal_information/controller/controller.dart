import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../profile/service/model/profile_model.dart';
import '../../profile/service/service.dart';
import '../service/modal/personal_info_field.dart';


class PersonalInformationController extends GetxController with Bindings {
  Rxn<ProfileModel> profileData = Rxn(null);
  RxBool hasError = RxBool(false);

  final RxList<PersonalInfoField> fields = <PersonalInfoField>[].obs;

  Future<ProfileModel> getProfile() async {
    hasError.value = false;
    return ProfileService.getProfile()
        .then((value) {
      profileData.value = value;
      fields.value = [
        PersonalInfoField(
          label: 'OFFICIAL EMAIL',
          value: value.email.isNotEmpty ? value.email : '-',
          icon: Icons.mail_outline_rounded,
        ),
        PersonalInfoField(
          label: 'EMPLOYEE ID CARD NUMBER',
          value: value.employeeCode.isNotEmpty? value.employeeCode : '-',
          icon: Icons.badge_outlined,
        ),
        PersonalInfoField(
          label: 'AUTO GENERATED EMPLOYEE ID',
          value: value.departmentId.isNotEmpty ? value.departmentId : '-',
          icon: Icons.fingerprint_rounded,
        ),
        PersonalInfoField(
          label: 'JOIN DATE',
          value: value.joiningDate.isNotEmpty ? value.joiningDate : '-',
          icon: Icons.calendar_today_outlined,
        ),
        PersonalInfoField(
          label: 'SALUTATION',
          value: value.division.isNotEmpty ? value.division : '-',
          icon: Icons.person_outline_rounded,
        ),
        PersonalInfoField(
          label: 'FULL NAME',
          value: value.name.isNotEmpty ? value.name : '-',
          icon: Icons.credit_card_outlined,
        ),
        PersonalInfoField(
          label: 'GENDER',
          value: value.name.isNotEmpty ? value.name : '-',
          icon: Icons.wc_outlined,
          isChip: true,
        ),
        PersonalInfoField(
          label: 'DATE OF BIRTH PASSPORT',
          value: value.joiningDate.isNotEmpty ? value.joiningDate : '-',
          icon: Icons.cake_outlined,
        ),
        PersonalInfoField(
          label: 'PERSONAL DATE OF BIRTH',
          value: value.joiningDate.isNotEmpty ? value.joiningDate : '-',
          icon: Icons.contact_page_outlined,
        ),
        PersonalInfoField(
          label: 'MARITAL STATUS',
          value: value.status.isNotEmpty ? value.status : '-',
          icon: Icons.favorite_border_rounded,
        ),
        PersonalInfoField(
          label: 'NATIONALITY',
          value: value.designation.isNotEmpty ? value.designation : '-',
          icon: Icons.public_outlined,
        ),
      ];
      return value;
    })
        .onError((error, stackTrace) {
      hasError.value = true;
      notificationHandler.apiErrorNotificationHandler(error: error);
      throw Exception();
    });
  }


  @override
  void dependencies() {
    Get.put(PersonalInformationController());
  }
}
