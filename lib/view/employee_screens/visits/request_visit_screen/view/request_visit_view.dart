import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/visits/request_visit_screen/controller/controller.dart';

class RequestVisitView extends GetView<RequestVisitController> {
  const RequestVisitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Request a Visit"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        buttonWidth: double.infinity,
        buttonName: 'Submit Visit Request',
        onPressed: controller.submitVisit,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            100.h,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(appSize.size16.w),
            decoration: BoxDecoration(
              color: appColors.whiteColor,
              borderRadius: BorderRadius.circular(appSize.radius16),
              boxShadow: [
                BoxShadow(
                  color: appColors.blackColor.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  title: 'Purpose of Visit',
                  controller: controller.purposeController,
                  hintText: 'Describe the purpose of your visit...',
                  radius: appSize.radius12,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 500,
                ),
                SizedBox(height: appSize.size16.h),
                Text('Location', style: fontStyles.font14Black600),
                SizedBox(height: appSize.size8.h),
                CustomTextField(
                  controller: controller.locationController,
                  hintText: 'Enter visit location',
                  radius: appSize.radius12,
                  prefix: Icon(
                    Icons.location_on_outlined,
                    color: appColors.lightGreyColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(height: appSize.size16.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => _IconPickerField(
                          label: 'Start Date',
                          value: controller.expectedStartDateLabel,
                          icon: Icons.calendar_month_outlined,
                          isPlaceholder:
                              controller.expectedStartDate.value == null,
                          onTap: controller.pickExpectedStartDate,
                        ),
                      ),
                    ),
                    SizedBox(width: appSize.size12.w),
                    Expanded(
                      child: Obx(
                        () => _IconPickerField(
                          label: 'Start Time',
                          value: controller.expectedStartTimeLabel,
                          icon: Icons.access_time_rounded,
                          isPlaceholder:
                              controller.expectedStartTime.value == null,
                          onTap: controller.pickExpectedStartTime,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appSize.size16.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => _IconPickerField(
                          label: 'End Date',
                          value: controller.expectedEndDateLabel,
                          icon: Icons.calendar_month_outlined,
                          isPlaceholder:
                              controller.expectedEndDate.value == null,
                          onTap: controller.pickExpectedEndDate,
                        ),
                      ),
                    ),
                    SizedBox(width: appSize.size12.w),
                    Expanded(
                      child: Obx(
                        () => _IconPickerField(
                          label: 'End Time',
                          value: controller.expectedEndTimeLabel,
                          icon: Icons.access_time_rounded,
                          isPlaceholder:
                              controller.expectedEndTime.value == null,
                          onTap: controller.pickExpectedEndTime,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appSize.size16.h),
                Text('Visitors', style: fontStyles.font14Black600),
                SizedBox(height: appSize.size8.h),
                Obx(() {
                  final visitors = controller.visitors;
                  return Column(
                    children: [
                      if (visitors.isNotEmpty) ...[
                        ...List.generate(visitors.length, (index) {
                          final visitor = visitors[index];
                          return _VisitorTile(
                            name: visitor.name,
                            designation: visitor.designation,
                            initials: visitor.initials,
                            onRemove: () => controller.removeVisitor(index),
                          );
                        }),
                        SizedBox(height: appSize.size8.h),
                      ],
                      InkWell(
                        onTap: controller.onAddVisitorTap,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: appSize.size12.w,
                            vertical: appSize.size12.h,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.whiteColor,
                            borderRadius: BorderRadius.circular(
                              appSize.radius12,
                            ),
                            border: Border.all(color: appColors.strokeColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                color: appColors.brandColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: appSize.size6.w),
                              Text(
                                visitors.isEmpty
                                    ? 'Add Visitor'
                                    : 'Add Another Visitor',
                                style: fontStyles.font14Brand700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: appSize.size16.h),
                CustomTextField(
                  title: 'Company',
                  controller: controller.companyController,
                  hintText: 'Enter company name',
                  radius: appSize.radius12,
                  maxLines: 1,
                ),
                SizedBox(height: appSize.size16.h),
                CustomTextField(
                  title: 'Contact Number',
                  controller: controller.contactController,
                  hintText: 'Enter contact number',
                  radius: appSize.radius12,
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: appSize.size16.h),
                CustomTextField(
                  title: 'Email',
                  controller: controller.emailController,
                  hintText: 'Enter email',
                  radius: appSize.radius12,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: appSize.size16.h),
                CustomTextField(
                  title: 'Remarks',
                  controller: controller.remarksController,
                  hintText: 'Add any additional remarks...',
                  radius: appSize.radius12,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _IconPickerField extends StatelessWidget {
  const _IconPickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: fontStyles.font14Black600),
        SizedBox(height: appSize.size8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(appSize.radius12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: appSize.size12.w,
              vertical: appSize.size14.h,
            ),
            decoration: BoxDecoration(
              color: appColors.whiteColor,
              borderRadius: BorderRadius.circular(appSize.radius12),
              border: Border.all(color: appColors.strokeColor),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16.sp, color: appColors.lightGreyColor),
                SizedBox(width: appSize.size8.w),
                Expanded(
                  child: Text(
                    value,
                    style: isPlaceholder
                        ? fontStyles.font12LightGrey500.copyWith(
                            letterSpacing: 0,
                          )
                        : fontStyles.font12LightGrey500.copyWith(
                            color: appColors.blackColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _VisitorTile extends StatelessWidget {
  const _VisitorTile({
    required this.name,
    required this.designation,
    required this.initials,
    required this.onRemove,
  });

  final String name;
  final String designation;
  final String initials;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: appSize.size8.h),
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size12.w,
        vertical: appSize.size10.h,
      ),
      decoration: BoxDecoration(
        color: appColors.scaffoldGreyColor,
        borderRadius: BorderRadius.circular(appSize.radius12),
        border: Border.all(color: appColors.strokeColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: appColors.profileIconBlueBg,
            child: Text(
              initials.length > 2 ? initials.substring(0, 2) : initials,
              style: fontStyles.font12Brand600,
            ),
          ),
          SizedBox(width: appSize.size10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: fontStyles.font14Black600),
                SizedBox(height: 2.h),
                Text(
                  designation,
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 18.sp,
              color: appColors.lightGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}
