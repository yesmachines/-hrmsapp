import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/view/employee_screens/profile/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/profile/view/widgets/profile_body.dart';
import 'package:yes_hrm/view/employee_screens/profile/view/widgets/profile_loading_widget.dart';
import 'package:yes_hrm/view/employee_screens/profile/view/widgets/profile_menu_tile.dart';

import '../../../../utils/no_data_page/no_data_page.dart';

class ProfileScreenView extends GetView<ProfileController> {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: appColors.scaffoldGreyColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          appSize.size16.w,
          appSize.size12.h,
          appSize.size16.w,
          appSize.size100.h,
        ),
        child: Column(
          children: [
            Text('Profile', style: fontStyles.font20Black700Fixed),
            SizedBox(height: appSize.size24.h),
            Obx(() {
              return FutureBuilder(
                future: controller.profileData.value == null
                    ? controller.getProfile()
                    : null,
                builder: (context, snapshot) {
                  if (controller.profileData.value == null &&
                      !controller.hasError.value) {
                    return const ProfileLoadingWidget();
                  } else if (controller.profileData.value != null) {
                    return ProfileBody(
                      profileData: controller.profileData.value!,
                    );
                  } else {
                    return const NoDataPage();
                  }
                },
              );
            }),
            // _ProfileAvatar(),
            // SizedBox(height: appSize.size16.h),
            // Obx(
            //   () => Text(
            //     controller.name.value,
            //     style: fontStyles.font20ProfileName700,
            //   ),
            // ),
            // SizedBox(height: appSize.size6.h),
            // Obx(
            //   () => Text(
            //     controller.jobTitle.value,
            //     style: fontStyles.font14Brand500,
            //   ),
            // ),
            // SizedBox(height: appSize.size4.h),
            // Obx(
            //   () => Text(
            //     controller.department.value,
            //     style: fontStyles.font14LightGrey400,
            //   ),
            // ),
            SizedBox(height: appSize.size24.h),
            ...controller.menuItems.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: appSize.size12.h),
                child: ProfileMenuTile(
                  item: item,
                  onTap: () => controller.onMenuTap(item),
                ),
              ),
            ),
            SizedBox(height: appSize.size16.h),
            CustomButton(
              buttonName: "Logout",
              prefixWidget: Padding(
                padding: EdgeInsets.only(),
                child: Icon(Icons.logout),
              ),
              buttonWidth: double.infinity,
              onPressed: controller.onLogout,
            ),
            SizedBox(height: appSize.size36.h),
          ],
        ),
      ),
    );
  }
}

// class _ProfileAvatar extends GetView<ProfileController> {
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final url = controller.avatarUrl.value;
//       return Container(
//         width: appSize.size100.w,
//         height: appSize.size100.w,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: appColors.profileIconBlueBg,
//           border: Border.all(color: appColors.whiteColor, width: 3),
//           boxShadow: [
//             BoxShadow(
//               color: appColors.blackColor.withValues(alpha: 0.08),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//           image: url.isNotEmpty
//               ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
//               : null,
//         ),
//         child: url.isEmpty
//             ? Icon(
//                 Icons.person_rounded,
//                 size: appSize.icon32 * 1.5,
//                 color: appColors.brandColor,
//               )
//             : null,
//       );
//     });
//   }
// }
