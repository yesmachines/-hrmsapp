import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';

import '../controller/controller.dart';
import 'widgets/contact_info_row.dart';

class ContactInformationView extends GetView<ContactInformationController> {
  const ContactInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      body: SafeArea(
        child: Column(
          children: [
            _ContactInfoAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  appSize.size16.w,
                  appSize.size8.h,
                  appSize.size16.w,
                  appSize.size16.h,
                ),
                child: _InfoCard(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size16.w,
                appSize.size8.h,
                appSize.size16.w,
                appSize.size16.h,
              ),
              child: CustomButton(
                buttonName: 'Save Changes',
                onPressed: controller.saveChanges,
                buttonWidth: double.infinity,
                radius: appSize.radius12,
                padding: EdgeInsets.symmetric(vertical: appSize.size16.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfoAppBar extends GetView<ContactInformationController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size8.w,
        vertical: appSize.size8.h,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(appSize.radius60),
            child: SizedBox(
              width: appSize.size44.w,
              height: appSize.size44.w,
              child: Center(
                child: ImageHandler(
                  imageType: ImageType.svg,
                  imageUrl: iconData.arrowLeftIconSvg,
                  width: appSize.icon20,
                  height: appSize.icon20,
                  svgImageColor: appColors.blackColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Contact Information',
              textAlign: TextAlign.center,
              style: fontStyles.font16Black700,
            ),
          ),
          InkWell(
            onTap: controller.toggleEdit,
            borderRadius: BorderRadius.circular(appSize.radius60),
            child: SizedBox(
              width: appSize.size44.w,
              height: appSize.size44.w,
              child: Icon(
                Icons.edit_outlined,
                color: appColors.brandColor,
                size: appSize.icon24,
              ),
            ),
          ),
          SizedBox(width: appSize.size4.w),
        ],
      ),
    );
  }
}

class _InfoCard extends GetView<ContactInformationController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size16.w,
        vertical: appSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius20),
        boxShadow: [
          BoxShadow(
            color: appColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final fields = controller.fields;
        return Column(
          children: List.generate(fields.length, (index) {
            return ContactInfoRow(
              field: fields[index],
              showDivider: index != fields.length - 1,
            );
          }),
        );
      }),
    );
  }
}
