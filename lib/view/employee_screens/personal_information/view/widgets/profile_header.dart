import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/view/employee_screens/personal_information/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/profile/service/model/profile_model.dart';

import '../../../../../main.dart';

class ProfileHeader extends GetView<PersonalInformationController> {
  const ProfileHeader({super.key, required this.profileInfo});
 final ProfileModel profileInfo;
  @override
  Widget build(BuildContext context) {
    final url = profileInfo.imageUrl;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
              ),
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
       Text(
            profileInfo.name,
            style: fontStyles.font20Black700Fixed,
          ),
        SizedBox(height: appSize.size4.h),
        Text(
            profileInfo.designation,
            style: fontStyles.font14LightGrey400,
          ),
      ],
    );
  }
}
