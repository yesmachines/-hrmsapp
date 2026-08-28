import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/assets/create_asset_request_screen/controller/controller.dart';

class CreateAssetRequestView extends GetView<CreateAssetRequestController> {
  const CreateAssetRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Create Request"),
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
                Text('Request Type', style: fontStyles.font12LightGrey500),
                SizedBox(height: appSize.size8.h),
                Obx(
                  () => _DropdownField(
                    value: controller.selectedRequestType.value,
                    onTap: controller.onRequestTypeTap,
                  ),
                ),
                SizedBox(height: appSize.size16.h),
                Text('Asset Category', style: fontStyles.font12LightGrey500),
                SizedBox(height: appSize.size8.h),
                Obx(
                  () => _DropdownField(
                    value: controller.selectedCategory.value ??
                        'Select category',
                    isPlaceholder: controller.selectedCategory.value == null,
                    onTap: controller.onCategoryTap,
                  ),
                ),
                SizedBox(height: appSize.size16.h),
                CustomTextField(
                  title: 'Reason / Description',
                  controller: controller.reasonController,
                  hintText: 'Provide detailed reasons for your request...',
                  radius: appSize.radius12,
                  minLines: 5,
                  maxLines: 8,
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
