import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';

class OrganizationChartController extends GetxController with Bindings {
  late final EmployeeDirectoryModel employee;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is EmployeeDirectoryModel) {
      employee = args;
    } else {
      employee = const EmployeeDirectoryModel(
        id: '0',
        name: 'Unknown',
        designation: '-',
        department: '-',
        email: '-',
        phone: '-',
      );
    }
    super.onInit();
  }

  List<OrgChartNode> get ancestors {
    return List.generate(employee.topLevel.length, (index) {
      return OrgChartNode(
        employee: employee.topLevel[index],
        level: index + 1,
      );
    });
  }

  OrgChartNode get current {
    return OrgChartNode(
      employee: employee,
      level: employee.topLevel.length + 1,
      isCurrent: true,
    );
  }

  List<OrgChartNode> get reports {
    final level = employee.topLevel.length + 2;
    return employee.lowLevel
        .map((item) => OrgChartNode(employee: item, level: level))
        .toList();
  }

  ({Color bg, Color text}) levelColors(int level) {
    switch ((level - 1) % 4) {
      case 0:
        return (bg: appColors.profileIconBlueBg, text: appColors.brandColor);
      case 1:
        return (bg: appColors.profileIconGreenBg, text: appColors.profileIconGreen);
      case 2:
        return (
          bg: appColors.profileIconPurpleBg,
          text: appColors.profileIconPurple,
        );
      default:
        return (bg: appColors.profileIconTealBg, text: appColors.profileIconTeal);
    }
  }

  @override
  void dependencies() {
    Get.put(OrganizationChartController());
  }
}

class OrgChartNode {
  const OrgChartNode({
    required this.employee,
    required this.level,
    this.isCurrent = false,
  });

  final EmployeeDirectoryModel employee;
  final int level;
  final bool isCurrent;
}
