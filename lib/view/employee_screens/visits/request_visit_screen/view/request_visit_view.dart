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
                Text('Visit Type', style: fontStyles.font14Black600),
                SizedBox(height: appSize.size8.h),
                Obx(
                  () => _DropdownField(
                    value: controller.selectedVisitType.value ??
                        'Select visit type',
                    isPlaceholder: controller.selectedVisitType.value == null,
                    onTap: controller.onVisitTypeTap,
                  ),
                ),
                SizedBox(height: appSize.size6.h),
                Text(
                  'Options: Customer Meeting, Supplier Visit, Other Visitor',
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: appSize.size16.h),
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
                          label: 'Visit Date',
                          value: controller.visitDateLabel,
                          icon: Icons.calendar_month_outlined,
                          isPlaceholder: controller.visitDate.value == null,
                          onTap: controller.pickVisitDate,
                        ),
                      ),
                    ),
                    SizedBox(width: appSize.size12.w),
                    Expanded(
                      child: Obx(
                        () => _IconPickerField(
                          label: 'Expected Time',
                          value: controller.expectedTimeLabel,
                          icon: Icons.access_time_rounded,
                          isPlaceholder: controller.expectedTime.value == null,
                          onTap: controller.pickExpectedTime,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appSize.size16.h),
                Text('Assigned Employees', style: fontStyles.font14Black600),
                SizedBox(height: appSize.size8.h),
                Obx(
                  () => InkWell(
                    onTap: controller.onAssignEmployeesTap,
                    borderRadius: BorderRadius.circular(appSize.radius12),
                      child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 48.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: appSize.size12.w,
                        vertical: appSize.size10.h,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.whiteColor,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                        border: Border.all(color: appColors.strokeColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: controller.assignedEmployees.isEmpty
                                ? Text(
                                    'Select employees',
                                    style: fontStyles.font14LightGrey400,
                                  )
                                : Wrap(
                                    spacing: appSize.size8.w,
                                    runSpacing: appSize.size8.h,
                                    children: controller.assignedEmployees
                                        .map(
                                          (employee) => _EmployeeChip(
                                            name: employee.name,
                                            initials: employee.initials ??
                                                employee.name[0],
                                            onRemove: () => controller
                                                .removeEmployee(employee),
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: appColors.lightGreyColor,
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: appSize.size16.h),
                Text('Required Approval', style: fontStyles.font14Black600),
                SizedBox(height: appSize.size8.h),
                Obx(
                  () => _DropdownField(
                    value: controller.selectedApprover.value ??
                        'Select approver',
                    isPlaceholder: controller.selectedApprover.value == null,
                    onTap: controller.onApproverTap,
                  ),
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
                SizedBox(height: appSize.size16.h),
                Text('Attachments', style: fontStyles.font14Black600),
                SizedBox(height: appSize.size8.h),
                Obx(() {
                  final files = controller.attachments;
                  if (files.isNotEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 90.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: files.length,
                            separatorBuilder: (_, _) =>
                                SizedBox(width: appSize.size10.w),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      appSize.radius12,
                                    ),
                                    child: Image.file(
                                      File(files[index].path),
                                      width: 90.w,
                                      height: 90.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4.h,
                                    right: 4.w,
                                    child: GestureDetector(
                                      onTap: () =>
                                          controller.removeAttachment(index),
                                      child: Container(
                                        padding: EdgeInsets.all(2.w),
                                        decoration: BoxDecoration(
                                          color: appColors.errorColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 12.sp,
                                          color: appColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: appSize.size10.h),
                        TextButton(
                          onPressed: controller.pickAttachments,
                          child: Text(
                            'Add more files',
                            style: fontStyles.font14Brand700,
                          ),
                        ),
                      ],
                    );
                  }
                  return InkWell(
                    onTap: controller.pickAttachments,
                    borderRadius: BorderRadius.circular(appSize.radius16),
                    child: CustomPaint(
                      painter: _DashedBorderPainter(
                        color: appColors.brandColor.withValues(alpha: 0.45),
                        radius: appSize.radius16,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: appSize.size24.h,
                          horizontal: appSize.size16.w,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: appColors.brandColor,
                              size: 28.sp,
                            ),
                            SizedBox(height: appSize.size8.h),
                            Text.rich(
                              TextSpan(
                                text: 'Attach files if required or ',
                                style: fontStyles.font12LightGrey500.copyWith(
                                  letterSpacing: 0,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Browse Files',
                                    style: fontStyles.font12Brand600,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = controller.pickAttachments,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String value;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(color: appColors.strokeColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: isPlaceholder
                    ? fontStyles.font14LightGrey400
                    : fontStyles.font14Black600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: appColors.lightGreyColor,
              size: 22.sp,
            ),
          ],
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

class _EmployeeChip extends StatelessWidget {
  const _EmployeeChip({
    required this.name,
    required this.initials,
    required this.onRemove,
  });

  final String name;
  final String initials;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        appSize.size6.w,
        appSize.size4.h,
        appSize.size8.w,
        appSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: appColors.scaffoldGreyColor,
        borderRadius: BorderRadius.circular(appSize.radius60),
        border: Border.all(color: appColors.strokeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10.r,
            backgroundColor: appColors.brandColor,
            child: Text(
              initials.length > 2 ? initials.substring(0, 2) : initials,
              style: fontStyles.font10White400.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: appSize.size6.w),
          Text(name, style: fontStyles.font12LightGrey500.copyWith(
            color: appColors.blackColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          )),
          SizedBox(width: appSize.size4.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14.sp, color: appColors.lightGreyColor),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + 6;
        dashed.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + 4;
      }
    }
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
