import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../../documents/controller/controller.dart';
import '../../employee_home_screen/controller/controller.dart';
import '../../profile/controller/controller.dart';

class EmployeeDashboardController extends GetxController with Bindings {
  final RxInt selectedNavIndex = 0.obs;
  final RxString employeeName = 'Safwan'.obs;
  final RxString dateLabel = 'TUESDAY, MAY 21, 2024'.obs;


  void onNavTap(int index) {
    selectedNavIndex.value = index;
  }

  @override
  void dependencies() {
    Get.put(EmployeeDashboardController());
    Get.put(HomeScreenController());
    Get.put(DocumentsController());
    Get.put(ProfileController());
  }
}
