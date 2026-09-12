import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/leave_apply_validation.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/apply_leave_info_card.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/apply_leave_upload_box.dart';

class LeaveTypeExtraFields extends GetView<ApplyLeaveController> {
  const LeaveTypeExtraFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final kind = controller.selectedKind;
      return Column(
        children: [
          if (controller.needsHandover)
            _AnnualFields(controller: controller),
          switch (kind) {
            LeaveApplyKind.annual => const SizedBox.shrink(),
            LeaveApplyKind.sick => _SickFields(controller: controller),
            LeaveApplyKind.compassionate =>
              _CompassionateFields(controller: controller),
            LeaveApplyKind.festival => _FestivalFields(controller: controller),
            LeaveApplyKind.maternity => _MaternityFields(controller: controller),
            LeaveApplyKind.parental => _ParentalFields(controller: controller),
            LeaveApplyKind.pilgrimage =>
              _PilgrimageFields(controller: controller),
            LeaveApplyKind.compensatory ||
            LeaveApplyKind.unpaid ||
            LeaveApplyKind.other => const SizedBox.shrink(),
          },
        ],
      );
    });
  }
}

class _AnnualFields extends StatelessWidget {
  const _AnnualFields({required this.controller});

  final ApplyLeaveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => _SelectField(
            title: 'Handover Person *',
            value: controller.selectedHandoverPerson.value?.name,
            placeholder: 'Select handover person',
            onTap: controller.onHandoverPersonTap,
          ),
        ),
        SizedBox(height: appSize.size12.h),
        CustomTextField(
          title: 'Handover Description *',
          controller: controller.handoverDescriptionController,
          hintText: 'Describe handover details...',
          minLines: 3,
          maxLines: 5,
          radius: appSize.radius16,
        ),
        SizedBox(height: appSize.size12.h),
        CustomTextField(
          title: 'Personal Contact Number *',
          controller: controller.personalContactController,
          hintText: 'Enter personal contact number',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: appSize.size12.h),
        CustomTextField(
          title: 'Emergency Local Contact Number *',
          controller: controller.emergencyContactController,
          hintText: 'Enter emergency local contact',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: appSize.size12.h),
        Obx(
          () => SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Travelling outside country?',
              style: fontStyles.font14Black600,
            ),
            value: controller.isTravellingOutside.value,
            activeThumbColor: appColors.brandColor,
            onChanged: (value) {
              controller.isTravellingOutside.value = value;
              if (value) {
                controller.declarationSigned.value = false;
              }
            },
          ),
        ),
        Obx(() {
          if (controller.isTravellingOutside.value) {
            return Column(
              children: [
                CustomTextField(
                  title: 'Destination *',
                  controller: controller.destinationController,
                  hintText: 'Enter destination country/city',
                ),
                SizedBox(height: appSize.size12.h),
                CustomTextField(
                  title: 'Travel Contact Number *',
                  controller: controller.travelContactController,
                  hintText: 'Enter travel contact number',
                  keyboardType: TextInputType.phone,
                ),
              ],
            );
          }
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: controller.declarationSigned.value,
            activeColor: appColors.brandColor,
            onChanged: (value) {
              controller.declarationSigned.value = value ?? false;
            },
            title: Text(
              'I sign the Declaration of Availability',
              style: fontStyles.font14Black600,
            ),
          );
        }),
        SizedBox(height: appSize.size12.h),
      ],
    );
  }
}

class _SickFields extends StatelessWidget {
  const _SickFields({required this.controller});

  final ApplyLeaveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => ApplyLeaveInfoCard(
            title: 'Sick Leave Pay Tier',
            icon: Icons.info_outline_rounded,
            accent: appColors.submittedBadgeText,
            background: appColors.submittedBadgeBg,
            children: [
              ApplyLeaveBullet(
                text: 'Calculated tier: ${controller.sickPayTierLabel}',
                color: const Color(0xFF1D4ED8),
              ),
              const ApplyLeaveBullet(
                text: 'First 15 Days → Full Pay',
                color: Color(0xFF1D4ED8),
              ),
              const ApplyLeaveBullet(
                text: 'Next 30 Days → Half Pay',
                color: Color(0xFF1D4ED8),
              ),
              const ApplyLeaveBullet(
                text: 'Remaining 45 Days → No Pay',
                color: Color(0xFF1D4ED8),
              ),
            ],
          ),
        ),
        SizedBox(height: appSize.size12.h),
        Obx(() {
          if (!controller.sickNeedsCertificate) {
            return const SizedBox.shrink();
          }
          return ApplyLeaveUploadBox(
            title: 'Upload Medical Certificate *',
            files: controller.certificates.toList(),
            onTap: controller.pickCertificate,
            onRemove: controller.removeCertificate,
          );
        }),
        SizedBox(height: appSize.size12.h),
      ],
    );
  }
}

class _CompassionateFields extends StatelessWidget {
  const _CompassionateFields({required this.controller});

  final ApplyLeaveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Relative *', style: fontStyles.font14Black600),
        SizedBox(height: appSize.size8.h),
        Obx(
          () => InkWell(
            onTap: controller.onRelativeTap,
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
                      controller.selectedRelative.value ?? 'Select relative',
                      style: fontStyles.font14Black600.copyWith(
                        color: controller.selectedRelative.value == null
                            ? appColors.lightGreyColor
                            : null,
                        fontWeight: controller.selectedRelative.value == null
                            ? FontWeight.w400
                            : null,
                      ),
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
        Obx(() {
          final limit = controller.selectedRelativeDayLimit;
          if (limit == null) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(top: appSize.size8.h),
            child: Text(
              'Maximum allowed: $limit days',
              style: fontStyles.font12LightGrey500,
            ),
          );
        }),
        SizedBox(height: appSize.size12.h),
      ],
    );
  }
}

class _FestivalFields extends StatelessWidget {
  const _FestivalFields({required this.controller});

  final ApplyLeaveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => _SelectField(
            title: 'Festival *',
            value: controller.selectedFestival.value?.name,
            placeholder: 'Select festival',
            onTap: controller.onFestivalTap,
          ),
        ),
        SizedBox(height: appSize.size12.h),
        Obx(
          () => ApplyLeaveInfoCard(
            title: 'Festival Leave Rules',
            icon: Icons.info_outline_rounded,
            accent: appColors.submittedBadgeText,
            background: appColors.submittedBadgeBg,
            children: [
              ApplyLeaveBullet(
                text: controller.alreadyTakenFestivalThisYear.value
                    ? 'Already taken this year — leave type is disabled'
                    : 'Not taken this year',
                color: const Color(0xFF1D4ED8),
              ),
              ApplyLeaveBullet(
                text:
                    'Nationality/Religion validation: ${controller.nationalityMatched.value && controller.religionMatched.value ? 'Eligible' : 'Not eligible'}',
                color: const Color(0xFF1D4ED8),
              ),
            ],
          ),
        ),
        SizedBox(height: appSize.size12.h),
      ],
    );
  }
}

class _MaternityFields extends StatelessWidget {
  const _MaternityFields({required this.controller});

  final ApplyLeaveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Due Date *', style: fontStyles.font14Black600),
        SizedBox(height: appSize.size8.h),
        Obx(
          () => InkWell(
            onTap: controller.pickDueDate,
            borderRadius: BorderRadius.circular(appSize.radius12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: appSize.size12.w,
                vertical: appSize.size12.h,
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
                      controller.formatDate(controller.dueDate.value),
                      style: fontStyles.font12LightGrey500.copyWith(
                        color: controller.dueDate.value == null
                            ? appColors.lightGreyColor
                            : appColors.blackColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16.sp,
                    color: appColors.lightGreyColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: appSize.size12.h),
        Obx(
          () => ApplyLeaveUploadBox(
            title: "Upload Doctor's Letter *",
            files: controller.doctorLetter.toList(),
            onTap: controller.pickCertificate,
            onRemove: controller.removeCertificate,
          ),
        ),
        SizedBox(height: appSize.size12.h),
      ],
    );
  }
}

class _ParentalFields extends StatelessWidget {
  const _ParentalFields({required this.controller});

  final ApplyLeaveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => _SelectField(
            title: "Child's Birth Date *",
            value: controller.childBirthDate.value == null
                ? null
                : controller.formatDate(controller.childBirthDate.value),
            placeholder: 'Select child birth date',
            onTap: controller.pickChildBirthDate,
            trailing: Icons.calendar_today_outlined,
          ),
        ),
        SizedBox(height: appSize.size12.h),
      ],
    );
  }
}

class _PilgrimageFields extends StatelessWidget {
  const _PilgrimageFields({required this.controller});

  final ApplyLeaveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => ApplyLeaveInfoCard(
            title: 'Pilgrimage Leave Rules',
            icon: Icons.info_outline_rounded,
            accent: appColors.submittedBadgeText,
            background: appColors.submittedBadgeBg,
            children: [
              ApplyLeaveBullet(
                text: controller.alreadyTakenPilgrimage.value
                    ? 'Already taken during tenure — leave type is disabled'
                    : 'Not taken during tenure — eligible',
                color: const Color(0xFF1D4ED8),
              ),
            ],
          ),
        ),
        SizedBox(height: appSize.size12.h),
      ],
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.title,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.trailing = Icons.keyboard_arrow_down_rounded,
  });

  final String title;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: fontStyles.font14Black600),
        SizedBox(height: appSize.size8.h),
        InkWell(
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
                    value ?? placeholder,
                    style: fontStyles.font14Black600.copyWith(
                      color: value == null ? appColors.lightGreyColor : null,
                      fontWeight: value == null ? FontWeight.w400 : null,
                    ),
                  ),
                ),
                Icon(
                  trailing,
                  color: appColors.lightGreyColor,
                  size: trailing == Icons.calendar_today_outlined
                      ? 16.sp
                      : 22.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
