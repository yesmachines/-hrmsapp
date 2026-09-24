import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/department_model.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/service.dart';

class EmployeeDirectoryController extends GetxController with Bindings {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxString searchQuery = ''.obs;
  final Rxn<DepartmentModel> selectedDepartment = Rxn();
  final RxList<DepartmentModel> departments = <DepartmentModel>[].obs;
  final RxBool departmentsLoading = false.obs;
  final Rxn<List<EmployeeDirectoryModel>> employees = Rxn(null);

  int currentPage = 1;
  int lastPage = 1;
  int _fetchId = 0;
  final RxInt filterVersion = 0.obs;
  Timer? _searchDebounce;

  bool get hasDepartmentFilter => selectedDepartment.value != null;

  String get departmentChipLabel {
    final department = selectedDepartment.value;
    if (department == null) return 'Department';
    final shortName = department.shortName;
    return shortName.isEmpty ? department.name : shortName;
  }

  String? get _departmentIdFilter {
    final departmentId = selectedDepartment.value?.id.trim() ?? '';
    if (departmentId.isEmpty) return null;
    return departmentId;
  }

  @override
  void onInit() {
    fetchDepartments();
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

  Future<void> fetchDepartments() async {
    departmentsLoading.value = true;
    try {
      final result = await EmployeeDirectoryService.getDepartments();
      departments.assignAll(result);
    } catch (_) {
      if (departments.isEmpty) {
        notificationHandler.sendNotification(
          message: 'Unable to load departments',
          notificationType: .error,
        );
      }
    } finally {
      departmentsLoading.value = false;
    }
  }

  void onDepartmentTap() {
    if (departments.isEmpty && !departmentsLoading.value) {
      fetchDepartments();
    }
    customBottomSheet(
      title: 'Department',
      child: Obx(() {
        if (departmentsLoading.value && departments.isEmpty) {
          return const SizedBox(height: 120, child: LoadingScreen());
        }
        if (departments.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
            child: Text(
              'No departments found',
              style: fontStyles.font14LightGrey400,
            ),
          );
        }
        return Column(
          children: [
            _departmentTile(department: null),
            ...departments.map(
              (department) => _departmentTile(department: department),
            ),
          ],
        );
      }),
    );
  }

  Widget _departmentTile({DepartmentModel? department}) {
    final selected = department == null
        ? selectedDepartment.value == null
        : selectedDepartment.value?.id == department.id &&
              selectedDepartment.value?.name == department.name;
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
          department == null ? 'All Departments' : department.name,
          style: fontStyles.font14Black600.copyWith(
            color: selected ? appColors.brandColor : appColors.blackColor,
          ),
        ),
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
          departmentId: _departmentIdFilter,
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
