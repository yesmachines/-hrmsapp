import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_home_screen/view/employee_home_screen_view.dart';
import 'package:yes_hrm/view/employee_screens/profile/view/profile_screen_view.dart';

import '../../calendar_screen/view/calendar_screen.dart';
import '../../documents/document_category/view/document_category_view.dart';
import '../controller/controller.dart';
import 'widgets/dashboard_bottom_nav.dart';

class EmployeeDashboardView extends GetView<EmployeeDashboardController> {
  const EmployeeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              switch (controller.selectedNavIndex.value) {
                case 2:
                  return const DocumentCategoryView();
                case 3:
                  return const ProfileScreenView();
                case 1:
                  return CalenderScreen();
                default:
                  return const EmployeeHomeScreenView();
              }
            }),
            const Align(
              alignment: Alignment.bottomCenter,
              child: DashboardBottomNav(),
            ),
          ],
        ),
      ),
    );
  }
}
