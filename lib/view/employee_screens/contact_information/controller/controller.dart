import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/view/employee_screens/profile/service/service.dart';

import '../../../../main.dart';
import '../../profile/service/model/profile_model.dart';
import '../service/model/contact_info_field.dart';

class ContactInformationController extends GetxController with Bindings {
  Rxn<ProfileModel> profileData = Rxn(null);
  RxBool hasError = RxBool(false);

  final RxList<ContactInfoField> fields = <ContactInfoField>[].obs;

  Future<ProfileModel> getProfile() async{
    hasError.value = false;
    return ProfileService.getProfile()
        .then((value){
          profileData.value = value;
          fields.value = [
            ContactInfoField(
              label: 'PERSONAL EMAIL',
              value: value.email.isNotEmpty ? value.email : '-',
              icon: Icons.mail_outline_rounded,
            ),
            ContactInfoField(
              label: 'HOME COUNTRY MOBILE NUMBER',
              value: value.phone.isNotEmpty ? value.phone : '-',
              icon: Icons.phone_outlined,
            ),
            ContactInfoField(
              label: 'OFFICE MOBILE NUMBER',
              value: value.phone.isNotEmpty ? value.phone : '-',
              icon: Icons.work_outline_rounded,
            ),
            ContactInfoField(
              label: 'UAE MOBILE NUMBER',
              value: value.phone.isNotEmpty ? value.phone : '-',
              icon: Icons.smartphone_outlined,
            ),
            ContactInfoField(
              label: 'UAE ADDRESS',
              value: value.officeLocationId.isNotEmpty ? value.officeLocationId : '-',
              icon: Icons.location_on_outlined,
            ),
            ContactInfoField(
              label: 'HOME COUNTRY ADDRESS',
              value: value.officeLocationId.isNotEmpty ? value.officeLocationId : '-',
              icon: Icons.home_outlined,
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
    // ContactInfoField(
    //   label: 'PERSONAL EMAIL',
    //   value: 'safwanv@gmail.com',
    //   icon: Icons.mail_outline_rounded,
    // ),
    // ContactInfoField(
    //   label: 'HOME COUNTRY MOBILE NUMBER',
    //   value: '+91 753 987 3678',
    //   icon: Icons.phone_outlined,
    // ),
    // ContactInfoField(
    //   label: 'OFFICE MOBILE NUMBER',
    //   value: '+91 986 342 5674',
    //   icon: Icons.work_outline_rounded,
    // ),
    // ContactInfoField(
    //   label: 'UAE MOBILE NUMBER',
    //   value: '+91 875 234 7643',
    //   icon: Icons.smartphone_outlined,
    // ),
    // ContactInfoField(
    //   label: 'UAE ADDRESS',
    //   value: 'Villa 42, Al Reem Island, Dubai',
    //   icon: Icons.location_on_outlined,
    // ),
    // ContactInfoField(
    //   label: 'HOME COUNTRY ADDRESS',
    //   value: 'Villa 18, Jumeirah Village, Dubai',
    //   icon: Icons.home_outlined,
    // ),

  @override
  void dependencies() {
    Get.put(ContactInformationController());
  }
}
