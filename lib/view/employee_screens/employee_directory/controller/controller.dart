import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/service.dart';

class EmployeeDirectoryController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxString searchQuery = ''.obs;
  final RxString selectedDepartment = 'Department'.obs;
  final Rxn<List<EmployeeDirectoryModel>> employees = Rxn(null);

  final departments = const [
    'Department',
    'Development Department',
    'Sales Department',
    'HR Department',
    'Marketing Department',
  ];

  int currentPage = 1;
  int lastPage = 1;
  int _fetchId = 0;
  final RxInt filterVersion = 0.obs;
  Timer? _searchDebounce;

  String? get _departmentFilter {
    final department = selectedDepartment.value;
    if (department == 'Department') return null;
    return department;
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.extentAfter == 0 &&
          currentPage <= lastPage) {
        if (currentPage != lastPage) {
          currentPage++;
          getEmployees();
        }
      }
    });
    super.onInit();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), applyFilters);
  }

  void applyFilters() {
    onRefresh();
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
              applyFilters();
            },
            borderRadius: BorderRadius.circular(appSize.radius12),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: appSize.size8.h),
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size14.w,
                vertical: appSize.size14.h,
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
                  color: selected ? appColors.brandColor : appColors.blackColor,
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

  Future<void> onRefresh() async {
    currentPage = 1;
    lastPage = 1;
    employees.value = null;
    filterVersion.value++;
  }

  Future<List<EmployeeDirectoryModel>> getEmployees() async {
    final fetchId = ++_fetchId;
    return EmployeeDirectoryService.getEmployees(
          page: currentPage,
          search: searchQuery.value,
          department: _departmentFilter,
        )
        .then((value) {
          if (fetchId != _fetchId) return value.employees;
          currentPage = value.pagination.currentPage;
          lastPage = value.pagination.lastPage;
          if (employees.value == null) {
            employees.value = value.employees;
          } else {
            employees.value = [...employees.value!, ...value.employees];
          }
          return value.employees;
        })
        .onError((error, stackTrace) {
          if (fetchId != _fetchId) throw Exception("");
          if (employees.value == null) {
            employees.value = [];
          }
          throw Exception("");
        });
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  @override
  void dependencies() {
    Get.put(EmployeeDirectoryController());
  }
}
