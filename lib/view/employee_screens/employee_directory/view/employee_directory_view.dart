import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/view/widgets/employee_directory_card.dart';

class EmployeeDirectoryView extends GetView<EmployeeDirectoryController> {
  const EmployeeDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Employee Directory"),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size8.h,
                appSize.size16.w,
                appSize.size12.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                      hintText: 'Search.....',
                      maxLines: 1,
                      radius: appSize.radius12,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: appSize.size14.h,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.whiteColor,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                        border: Border.all(color: appColors.strokeColor),
                      ),
                      prefix: Icon(
                        Icons.search_rounded,
                        color: appColors.lightGreyColor,
                        size: appSize.icon20,
                      ),
                    ),
                  ),
                  SizedBox(width: appSize.size10.w),
                  Obx(
                    () => InkWell(
                      onTap: controller.onDepartmentTap,
                      borderRadius: BorderRadius.circular(appSize.radius12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: appSize.size12.w,
                          vertical: appSize.size14.h,
                        ),
                        decoration: BoxDecoration(
                          color: controller.selectedDepartment.value ==
                                  'Department'
                              ? appColors.whiteColor
                              : appColors.submittedBadgeBg,
                          borderRadius: BorderRadius.circular(appSize.radius12),
                          border: Border.all(
                            color: controller.selectedDepartment.value ==
                                    'Department'
                                ? appColors.strokeColor
                                : appColors.brandColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.selectedDepartment.value ==
                                      'Department'
                                  ? 'Department'
                                  : controller.selectedDepartment.value
                                      .replaceAll(' Department', ''),
                              style: fontStyles.font12LightGrey500.copyWith(
                                color: controller.selectedDepartment.value ==
                                        'Department'
                                    ? appColors.blackColor
                                    : appColors.brandColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(width: appSize.size4.w),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18.sp,
                              color: appColors.lightGreyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return FutureBuilder(
                  key: ValueKey(controller.filterVersion.value),
                  future: controller.employees.value == null
                      ? controller.getEmployees()
                      : null,
                  builder: (context, snapshot) {
                    if (controller.employees.value == null) {
                      return const LoadingScreen();
                    } else if (controller.employees.value!.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: controller.onRefresh,
                        child: ListView.builder(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            appSize.size16.w,
                            0,
                            appSize.size16.w,
                            appSize.size24.h,
                          ),
                          itemCount: controller.employees.value!.length,
                          itemBuilder: (context, index) {
                            return EmployeeDirectoryCard(
                              employee: controller.employees.value![index],
                            );
                          },
                        ),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: controller.onRefresh,
                        child: const SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: 400,
                            child: NoDataPage(),
                          ),
                        ),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
