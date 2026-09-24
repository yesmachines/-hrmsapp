import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/create_letter_request/controller/controller.dart';

class CreateLetterRequestView extends GetView<CreateLetterRequestController> {
  const CreateLetterRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Create Letter Request"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        buttonWidth: double.infinity,
        buttonName: 'Submit Request',
        onPressed: controller.submitRequest,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            100.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Letter Type', style: fontStyles.font14Black600),
              SizedBox(height: appSize.size8.h),
              Obx(
                () => _SelectField(
                  value: controller.typeLabel,
                  isPlaceholder: controller.selectedType.value == null,
                  onTap: controller.onTypeTap,
                ),
              ),
              SizedBox(height: appSize.size16.h),
              Text('Template', style: fontStyles.font14Black600),
              SizedBox(height: appSize.size8.h),
              Obx(
                () => _SelectField(
                  value: controller.templateLabel,
                  isPlaceholder: controller.selectedTemplate.value == null,
                  onTap: controller.onTemplateTap,
                ),
              ),
              SizedBox(height: appSize.size16.h),
              CustomTextField(
                title: 'Purpose',
                controller: controller.purposeController,
                hintText: 'Employment Visa Renewal',
                maxLines: 1,
                maxLength: 150,
              ),
              SizedBox(height: appSize.size16.h),
              CustomTextField(
                title: 'Details',
                controller: controller.detailsController,
                hintText:
                    'Requesting an official NOC for embassy submission regarding visa renewal.',
                radius: appSize.radius12,
                minLines: 4,
                maxLines: 6,
                maxLength: 500,
              ),
              SizedBox(height: appSize.size16.h),
              CustomTextField(
                title: 'To Address',
                controller: controller.toAddressController,
                hintText: 'Embassy of France, Visa Section, Dubai',
                radius: appSize.radius12,
                minLines: 2,
                maxLines: 4,
                maxLength: 250,
              ),
              SizedBox(height: appSize.size16.h),
              CustomTextField(
                title: 'Visa Designation',
                controller: controller.visaDesignationController,
                hintText: 'Senior Software Engineer',
                maxLines: 1,
                maxLength: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
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
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
