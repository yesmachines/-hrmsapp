import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

class ProfileMenuItem {
  const ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
}

class ProfileController extends GetxController with Bindings {
  final RxString name = 'Safwan V'.obs;
  final RxString jobTitle = 'Senior Flutter Developer'.obs;
  final RxString department = 'Information Technology'.obs;
  final RxString avatarUrl = ''.obs;

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
    ProfileMenuItem(
      title: 'Document Information',
      icon: Icons.description_rounded,
      iconColor: appColors.profileIconTeal,
      backgroundColor: appColors.profileIconTealBg,
    ),
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
      case 'Document Information':
        Get.toNamed(appRoutes.documentInformation);
        break;
      default:
        break;
    }
  }

  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
