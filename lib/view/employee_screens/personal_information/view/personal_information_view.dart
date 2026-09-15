import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/personal_information/view/widgets/info_card.dart';
import 'package:yes_hrm/view/employee_screens/personal_information/view/widgets/profile_header.dart';

import '../../profile/view/widgets/profile_loading_widget.dart';
import '../controller/controller.dart';
import 'widgets/personal_info_row.dart';

class PersonalInformationView extends GetView<PersonalInformationController> {
  const PersonalInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      body: SafeArea(
        child: Column(
          children: [
            _PersonalInfoAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  appSize.size16.w,
                  appSize.size8.h,
                  appSize.size16.w,
                  appSize.size16.h,
                ),
                child: Column(
                  children: [
                    Obx(
                      () => FutureBuilder(
                        future: controller.profileData.value == null
                            ? controller.getProfile()
                            : null,
                        builder: (context, snapshot) {
                          if (controller.profileData.value == null &&
                              !controller.hasError.value) {
                            return const ProfileLoadingWidget();
                          } else if (controller.profileData.value != null) {
                            return Column(
                              children: [
                                ProfileHeader(
                                  profileInfo: controller.profileData.value!,),
                                SizedBox(height: appSize.size20.h),
                                InfoCard(),
                              ],
                            );
                          } else {
                            return NoDataPage();
                          }
                        }
                      ),
                    ),
                  ],
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

class _PersonalInfoAppBar extends GetView<PersonalInformationController> {
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
              'Personal Information',
              textAlign: TextAlign.center,
              style: fontStyles.font16Black700,
            ),
          ),
          Obx(
            () => InkWell(
              onTap: controller.toggleEdit,
              borderRadius: BorderRadius.circular(appSize.radius8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size14.w,
                  vertical: appSize.size8.h,
                ),
                decoration: BoxDecoration(
                  color: appColors.profileIconBlueBg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Text(
                  controller.isEditing.value ? 'Cancel' : 'Edit',
                  style: fontStyles.font12Brand600,
                ),
              ),
            ),
          ),
          SizedBox(width: appSize.size8.w),
        ],
      ),
    );
  }
}
