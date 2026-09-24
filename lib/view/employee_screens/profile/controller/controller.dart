import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/middleware/api_call_handler/api_call_handler.dart';
import 'package:yes_hrm/view/authentication/login_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/profile/service/model/profile_model.dart';

import '../service/model/Profile_Menu_item.dart';
import '../service/service.dart';

class ProfileController extends GetxController with Bindings {
  Rxn<ProfileModel> profileData = Rxn(null);
  RxBool hasError = RxBool(false);

  Future<ProfileModel> getProfile() async {
    hasError.value = false;
    return ProfileService.getProfile()
        .then((value) {
      profileData.value = value;
      return value;
    })
        .onError((error, stackTrace) {
      hasError.value = true;
      notificationHandler.apiErrorNotificationHandler(error: error);
      throw Exception();
    });
  }

  late final List<ProfileMenuItem> menuItems = [
    ProfileMenuItem(
      title: 'Personal Information',
      icon: Icons.person_rounded,
      iconColor: appColors.profileIconBlue,
      backgroundColor: appColors.profileIconBlueBg,
    ),
    ProfileMenuItem(
      title: 'Employment Information',
      icon: Icons.work_rounded,
      iconColor: appColors.profileIconPurple,
      backgroundColor: appColors.profileIconPurpleBg,
    ),
    ProfileMenuItem(
      title: 'Contact Information',
      icon: Icons.phone_rounded,
      iconColor: appColors.profileIconGreen,
      backgroundColor: appColors.profileIconGreenBg,
    ),
    ProfileMenuItem(
      title: 'Emergency Contact',
      icon: Icons.health_and_safety_rounded,
      iconColor: appColors.profileIconPink,
      backgroundColor: appColors.profileIconPinkBg,
    ),
    ProfileMenuItem(
      title: 'Education & Experience',
      icon: Icons.school_rounded,
      iconColor: appColors.profileIconOrange,
      backgroundColor: appColors.profileIconOrangeBg,
    ),
    // ProfileMenuItem(
    //   title: 'Document Information',
    //   icon: Icons.description_rounded,
    //   iconColor: appColors.profileIconTeal,
    //   backgroundColor: appColors.profileIconTealBg,
    // ),
  ];

  void onMenuTap(ProfileMenuItem item) {
    switch (item.title) {
      case 'Personal Information':
        Get.toNamed(appRoutes.personalInformation);
        break;
      case 'Employment Information':
        Get.toNamed(appRoutes.employmentInformation);
        break;
      case 'Contact Information':
        Get.toNamed(appRoutes.contactInformation);
        break;
      case 'Emergency Contact':
        Get.toNamed(appRoutes.emergencyContact);
        break;
      case 'Education & Experience':
        Get.toNamed(appRoutes.educationExperience);
        break;
      // case 'Document Information':
      //   Get.toNamed(appRoutes.documentInformation);
      //   break;
      default:
        break;
    }
  }

  Future<void> onLogout() async {
    loadingScreen();
    try {
      await LoginService.logout();
    } catch (_) {}
    await sharedDataHandler.clearSharedData();
    resetDioClient();
    Get.back();
    Get.offAllNamed(appRoutes.loginScreen);
  }

  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
