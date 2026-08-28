import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/leave_apply_validation.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/apply_leave_info_card.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/apply_leave_upload_box.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/leave_type_extra_fields.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/leave_type_widget.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/user_info_widget.dart';

class ApplyLeaveView extends GetView<ApplyLeaveController> {
  const ApplyLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Apply Leave"),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.leaveMetaData.value == null
              ? controller.getLeaveMetaData()
              : null,
          builder: (context, asyncSnapshot) {
            if (controller.leaveMetaData.value == null &&
                controller.leaveMetaDataHasError.value == false) {
              return Center(child: LoadingScreen());
            } else if (controller.leaveMetaData.value != null) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  appSize.size16.w,
                  appSize.size8.h,
                  appSize.size16.w,
                  100.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfoWidget(),
                    SizedBox(height: appSize.size20.h),
                    Text.rich(
                      TextSpan(
                        text: 'Leave Type ',
                        style: fontStyles.font14Black600,
                        children: [
                          TextSpan(
                            text: '*',
                            style: fontStyles.font14Black600.copyWith(
                              color: appColors.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: appSize.size8.h),
                    LeaveTypeWidget(),
                    SizedBox(height: appSize.size16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Obx(
                                () => _DateField(
                                  label: 'START DATE',
                                  value: controller.formatDate(
                                    controller.startDate.value,
                                  ),
                                  onTap: controller.pickStartDate,
                                ),
                              ),
                              SizedBox(height: appSize.size12.h),
                              Obx(
                                () => _DateField(
                                  label: 'END DATE',
                                  value: controller.formatDate(
                                    controller.endDate.value,
                                  ),
                                  onTap: controller.pickEndDate,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: appSize.size12.w),
                        Expanded(
                          child: Column(
                            children: [
                              Obx(
                                () => _StatChip(
                                  label: 'Leave Applied',
                                  value: '${controller.leaveAppliedDays} Days',
                                  bg: appColors.submittedBadgeBg,
                                  textColor: appColors.submittedBadgeText,
                                ),
                              ),
                              SizedBox(height: appSize.size12.h),
                              Obx(
                                () => _StatChip(
                                  label: 'Remaining Balance',
                                  value:
                                      '${controller.remainingBalance} Days',
                                  bg: appColors.activeBadgeBg,
                                  textColor: appColors.activeBadgeText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: appSize.size16.h),
                    CustomTextField(
                      title: 'Remarks *',
                      controller: controller.remarksController,
                      hintText: 'Write your remarks...',
                      radius: appSize.radius16,
                      minLines: 4,
                      maxLines: 6,
                      maxLength: 500,
                    ),
                    SizedBox(height: appSize.size16.h),
                    const LeaveTypeExtraFields(),
                    Obx(() {
                      if (!controller.showUploadBox ||
                          controller.selectedKind ==
                              LeaveApplyKind.sick ||
                          controller.selectedKind ==
                              LeaveApplyKind.maternity) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: appSize.size16.h),
                        child: ApplyLeaveUploadBox(
                          title: controller.uploadTitle,
                          files: controller.certificates.toList(),
                          onTap: controller.pickCertificate,
                          onRemove: controller.removeCertificate,
                        ),
                      );
                    }),
                    Obx(() {
                      if (controller.selectedKind != LeaveApplyKind.sick) {
                        return const SizedBox.shrink();
                      }
                      return ApplyLeaveInfoCard(
                        title: 'Important Rules',
                        icon: Icons.warning_amber_rounded,
                        accent: appColors.expiringBadgeText,
                        background: appColors.expiringBadgeBg,
                        children: const [
                          ApplyLeaveBullet(
                            text:
                                'If leave is combined with a weekend, a medical certificate is mandatory.',
                            color: Color(0xFFEA580C),
                          ),
                          ApplyLeaveBullet(
                            text:
                                'For more than 2 consecutive days, uploading a sick leave certificate is required.',
                            color: Color(0xFFEA580C),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            } else {
              return NoDataPage(
                message:
                    "You cannot apply for leave right now, contact HR for more details.",
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        buttonWidth: double.infinity,
        buttonName: 'Submit Leave Request',
        onPressed: controller.submitLeave,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: fontStyles.font10LightGrey500.copyWith(
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: appSize.size6.h),
        InkWell(
          onTap: onTap,
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
                    value,
                    style: fontStyles.font12LightGrey500.copyWith(
                      color: appColors.blackColor,
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
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.bg,
    required this.textColor,
  });

  final String label;
  final String value;
  final Color bg;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: fontStyles.font10LightGrey500.copyWith(
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: appSize.size6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: appSize.size12.w,
            vertical: appSize.size12.h,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(appSize.radius12),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: fontStyles.font14Black600.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
