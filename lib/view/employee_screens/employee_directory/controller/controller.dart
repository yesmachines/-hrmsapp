import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';

class EmployeeDirectoryController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedDepartment = 'Department'.obs;

  final departments = const [
    'Department',
    'Development Department',
    'Sales Department',
    'HR Department',
    'Marketing Department',
  ];

  late final List<EmployeeDirectoryModel> employees = [
    const EmployeeDirectoryModel(
      id: '1',
      name: 'Swathika K',
      designation: 'UI/UX Designer',
      department: 'Development Department',
      email: 'swathika@company.com',
      phone: '+971 50 123 457',
      joinDate: '15 May 2021',
    ),
    const EmployeeDirectoryModel(
      id: '2',
      name: 'Ahmed Hassan',
      designation: 'Sales Executive',
      department: 'Sales Department',
      email: 'ahmed@company.com',
      phone: '+9 71 50 234 568',
    ),
    const EmployeeDirectoryModel(
      id: '3',
      name: 'Priya Nair',
      designation: 'HR Manager',
      department: 'HR Department',
      email: 'priya@company.com',
      phone: '+9 71 50 345 679',
    ),
    const EmployeeDirectoryModel(
      id: '4',
      name: 'Mohammed Ali',
      designation: 'Flutter Developer',
      department: 'Development Department',
      email: 'mohammed@company.com',
      phone: '+9 71 50 456 780',
    ),
    const EmployeeDirectoryModel(
      id: '5',
      name: 'Sara Khan',
      designation: 'Marketing Lead',
      department: 'Marketing Department',
      email: 'sara@company.com',
      phone: '+9 71 50 567 891',
    ),
  ];

  List<EmployeeDirectoryModel> get filteredEmployees {
    final query = searchQuery.value.trim().toLowerCase();
    return employees.where((employee) {
      final matchesDepartment = selectedDepartment.value == 'Department' ||
          employee.department == selectedDepartment.value;
      if (!matchesDepartment) return false;
      if (query.isEmpty) return true;
      return employee.name.toLowerCase().contains(query) ||
          employee.designation.toLowerCase().contains(query) ||
          employee.department.toLowerCase().contains(query) ||
          employee.email.toLowerCase().contains(query) ||
          employee.phone.toLowerCase().contains(query);
    }).toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onDepartmentTap() {
    customBottomSheet(
      title: 'Department',
      child: Column(
        children: departments.map((department) {
          final selected = department == selectedDepartment.value;
          return InkWell(
            onTap: () {
              selectedDepartment.value = department;
              Get.back();
            },
            borderRadius: BorderRadius.circular(appSize.radius12),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: appSize.size8),
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size14,
                vertical: appSize.size14,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? appColors.submittedBadgeBg
                    : appColors.scaffoldGreyColor,
                borderRadius: BorderRadius.circular(appSize.radius12),
                border: Border.all(
                  color: selected
                      ? appColors.brandColor.withValues(alpha: 0.35)
                      : appColors.strokeColor,
                ),
              ),
              child: Text(
                department == 'Department' ? 'All Departments' : department,
                style: fontStyles.font14Black600.copyWith(
                  color:
                      selected ? appColors.brandColor : appColors.blackColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void onViewEmployee(EmployeeDirectoryModel employee) {
    Get.toNamed(appRoutes.employeeDetails, arguments: employee);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(EmployeeDirectoryController());
  }
}
