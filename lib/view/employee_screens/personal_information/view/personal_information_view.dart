import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';

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
                    _ProfileHeader(),
                    SizedBox(height: appSize.size20.h),
                    _InfoCard(),
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

class _ProfileHeader extends GetView<PersonalInformationController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(() {
              final url = controller.avatarUrl.value;
              return Container(
                width: appSize.size100.w,
                height: appSize.size100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColors.profileIconBlueBg,
                  border: Border.all(color: appColors.whiteColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.blackColor.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: url.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: url.isEmpty
                    ? Icon(
                        Icons.person_rounded,
                        size: appSize.icon32 * 1.4,
                        color: appColors.brandColor,
                      )
                    : null,
              );
            }),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: controller.onChangePhoto,
                borderRadius: BorderRadius.circular(appSize.radius60),
                child: Container(
                  width: appSize.size32.w,
                  height: appSize.size32.w,
                  decoration: BoxDecoration(
                    color: appColors.brandColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: appColors.whiteColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: appColors.whiteColor,
                    size: appSize.icon16,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: appSize.size14.h),
        Obx(
          () => Text(
            controller.name.value,
            style: fontStyles.font20Black700Fixed,
          ),
        ),
        SizedBox(height: appSize.size4.h),
        Obx(
          () => Text(
            controller.jobTitle.value,
            style: fontStyles.font14LightGrey400,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends GetView<PersonalInformationController> {
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
            return PersonalInfoRow(
              field: fields[index],
              showDivider: index != fields.length - 1,
            );
          }),
        );
      }),
    );
  }
}
