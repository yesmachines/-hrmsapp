import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/view/employee_screens/create_post_screen/view/widgets/add_photo_container.dart';
import 'package:yes_hrm/view/employee_screens/create_post_screen/view/widgets/profile_image.dart';

import '../../../../../../../main.dart';
import '../controller/controller.dart';

class CreatePostScreen extends GetView<CreatePostController> {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(
        title: "Create Post",
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: appSize.size16.w,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: appSize.size6.h),

                    Row(
                      children: [
                        ProfileImage(
                          image: controller.profileImage,
                          name: controller.userName,
                        ),

                        SizedBox(width: appSize.size12.w),

                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.userName,
                              style: fontStyles.font14White600.copyWith(color: appColors.profileText)
                            ),

                            Text(
                              'Employee',
                              style: fontStyles.font12White500.copyWith(color: appColors.subText)
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: appSize.size22.h),

                    Text(
                      'Caption',
                      style: fontStyles.font14Black600
                    ),

                    SizedBox(height: appSize.size8.h),

                    Container(
                      height: appSize.size120.h,
                      decoration: BoxDecoration(
                        color: appColors.whiteColor,
                        borderRadius:
                        BorderRadius.circular(appSize.radius12.r),
                        border: Border.all(
                          color: Color(0xFFE4E7EC),
                        ),
                      ),
                      child: TextField(
                        controller:
                        controller.captionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical:
                        TextAlignVertical.top,
                        style: fontStyles.font14LightGrey400.copyWith(color: appColors.blackColor),
                        decoration: InputDecoration(
                          hintText:
                          'What would you like to share?',
                          hintStyle: fontStyles.font14LightGrey400.copyWith(color: appColors.subText),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(
                            horizontal: appSize.size12.w,
                            vertical: appSize.size12.h,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: appSize.size20.h),

                    Padding(
                      padding: EdgeInsets.only(
                        left: appSize.size8.w,
                      ),
                      child: Text(
                        'Add Photo',
                        style: fontStyles.font16White600.copyWith(color: appColors.blackColor)
                      ),
                    ),

                    SizedBox(height: appSize.size8.h),

                    Obx(
                          () {
                        final image =
                            controller.selectedImage.value;

                        if (image == null) {
                          return AddPhotoContainer(
                            onTap: controller.pickImage,
                          );
                        }

                        return _SelectedImage(
                          image: image,
                          onRemove:
                          controller.removeImage,
                        );
                      },
                    ),

                    Obx(
                          () {
                        if (controller
                            .selectedImage
                            .value ==
                            null) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            SizedBox(height: appSize.size8.h),

                            Center(
                              child: InkWell(
                                onTap:
                                controller.pickImage,
                                child: Text(
                                  'Change Photo',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight:
                                    FontWeight.w600,
                                    color:
                                    appColors.brandColor,
                                    decoration:
                                    TextDecoration
                                        .underline,
                                    decorationColor:
                                    appColors.brandColor
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: appSize.size20.h),

                    CustomButton(
                      buttonWidth: double.infinity,
                        buttonName: "Post",
                        onPressed: controller.createPost
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _SelectedImage extends StatelessWidget {
  const _SelectedImage({
    required this.image,
    required this.onRemove,
  });

  final XFile image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3.r),
          child: Image.file(
            File(image.path),
            width: double.infinity,
            height: 220.h,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: appSize.size8.h,
          right: appSize.size8.w,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              width: appSize.size24.w,
              height: appSize.size24.w,
              decoration: BoxDecoration(
                color: Color(0xFFF6F9FC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: appSize.size16.sp,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ),
      ],
    );
  }
}