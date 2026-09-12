import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';

class HandoverPersonSheet extends GetView<ApplyLeaveController> {
  const HandoverPersonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: controller.handoverSearchController,
          onChanged: controller.onHandoverSearchChanged,
          hintText: 'Search employee',
          maxLines: 1,
          radius: appSize.radius12,
          contentPadding: EdgeInsets.symmetric(vertical: appSize.size14.h),
          prefix: Icon(
            Icons.search_rounded,
            color: appColors.lightGreyColor,
            size: appSize.icon20,
          ),
        ),
        SizedBox(height: appSize.size12.h),
        SizedBox(
          height: Get.height * 0.42,
          child: Obx(() {
            if (controller.employeesLoading.value &&
                controller.employees.isEmpty) {
              return const Center(child: LoadingScreen());
            }
            final employees = controller.filteredHandoverEmployees;
            if (employees.isEmpty) {
              return Center(
                child: Text(
                  controller.employeesHasError.value
                      ? 'Unable to load employees'
                      : 'No employees found',
                  style: fontStyles.font14LightGrey400,
                ),
              );
            }
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return _EmployeeTile(
                  employee: employee,
                  selected:
                      employee.id == controller.selectedHandoverPerson.value?.id,
                  onTap: () => controller.onHandoverPersonSelected(employee),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.employee,
    required this.selected,
    required this.onTap,
  });

  final EmployeeModel employee;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: appSize.size8),
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14,
          vertical: appSize.size12,
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
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColors.profileIconBlueBg,
                image: employee.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(employee.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: employee.imageUrl.isEmpty
                  ? Center(
                      child: Text(
                        employee.name.isNotEmpty
                            ? employee.name[0].toUpperCase()
                            : '?',
                        style: fontStyles.font14Black600.copyWith(
                          color: appColors.brandColor,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: appSize.size10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: fontStyles.font14Black600.copyWith(
                      color: selected
                          ? appColors.brandColor
                          : appColors.blackColor,
                    ),
                  ),
                  if (employee.designation.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      employee.designation,
                      style: fontStyles.font12LightGrey500,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
