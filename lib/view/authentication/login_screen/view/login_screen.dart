import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';

import '../controller/controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: appSize.size20.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: appSize.size24.h),
                      ImageHandler(
                        imageType: ImageType.asset,
                        imageUrl: imageData.loginIllustration,
                        width: screenUtil.screenWidth,
                        boxFit: BoxFit.contain,
                      ),
                      SizedBox(height: appSize.size16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          appSize.size24.w,
                          appSize.size32.h,
                          appSize.size24.w,
                          appSize.size32.h,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.whiteColor,
                          borderRadius: BorderRadius.circular(appSize.radius24),
                          boxShadow: [
                            BoxShadow(
                              color: appColors.blackColor.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: fontStyles.font24Brand700,
                            ),
                            SizedBox(height: appSize.size8.h),
                            Text(
                              'Sign in to continue',
                              style: fontStyles.font14LightGrey400,
                            ),
                            SizedBox(height: appSize.size32.h),
                            CustomTextField(
                              controller: controller.emailController,
                              hintText: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              radius: appSize.radius12,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: appSize.size16.h,
                              ),
                              prefix: ImageHandler(
                                imageType: ImageType.svg,
                                imageUrl: iconData.emailIconSvg,
                                width: appSize.icon16,
                                height: appSize.icon16,
                                boxFit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: appSize.size16.h),
                            Obx(
                              () =>  CustomTextField(
                                controller: controller.passwordController,
                                hintText: 'Password',
                                isObscure: !controller.isPasswordVisible.value,
                                maxLines: 1,
                                radius: appSize.radius12,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: appSize.size16.h,
                                ),
                                prefix: ImageHandler(
                                  imageType: ImageType.svg,
                                  imageUrl: iconData.lockIconSvg,
                                  width: appSize.icon20,
                                  height: appSize.icon20,
                                  boxFit: BoxFit.contain,
                                ),
                                suffix: InkWell(
                                  onTap: controller.togglePasswordVisibility,
                                  child: ImageHandler(
                                    imageType: ImageType.svg,
                                    imageUrl: controller.isPasswordVisible.value
                                        ? iconData.eyeOffIconSvg
                                        : iconData.eyeIconSvg,
                                    width: appSize.icon18,
                                    height: appSize.icon18,
                                  ),
                                )
                              ),
                            ),
                            SizedBox(height: appSize.size32.h),
                            CustomButton(
                              buttonName: 'SIGN IN',
                              onPressed: controller.onSignIn,
                              buttonWidth: double.infinity,
                              radius: appSize.radius12,
                              padding: EdgeInsets.symmetric(
                                vertical: appSize.size16.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
