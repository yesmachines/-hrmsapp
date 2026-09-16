import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/contact_information/view/widgets/_info_card.dart';

import '../../profile/view/widgets/profile_loading_widget.dart';
import '../controller/controller.dart';

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
                child: Obx(
                  () => FutureBuilder(
                    future: controller.profileData.value == null
                        ? controller.getProfile()
                        : null,
                    builder: (context, snapshot) {
                      if (controller.profileData.value == null &&
                          !controller.hasError.value) {
                        return const ProfileLoadingWidget();
                      } else if (controller.profileData.value != null) {
                        return InfoCard();
                      } else {
                        return NoDataPage();
                      }
                    }
                  ),
                ),
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
