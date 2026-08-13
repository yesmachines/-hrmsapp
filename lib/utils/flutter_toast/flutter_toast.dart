import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../main.dart';

class NotificationHandler {
  sendNotification({
    required String message,
    required NotificationType notificationType,
    String title = "",
  }) {
    late Color backGroundColor;
    switch (notificationType) {
      case NotificationType.success:
        backGroundColor = appColors.brandColor;
      case NotificationType.warning:
        backGroundColor = appColors.lightOrangeColor;
      case NotificationType.error:
        backGroundColor = appColors.errorColor;
    }
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.snackbar(
      "",
      "",
      snackPosition: SnackPosition.TOP,
      titleText: const SizedBox(),
      messageText: Text(
        message,
        style: fontStyles.font14LightGrey400.copyWith(
          color: appColors.whiteColor,
        ),
      ),
      isDismissible: true,
      colorText: appColors.whiteColor,
      backgroundColor: backGroundColor,
      margin: EdgeInsets.all(appSize.size16.sp),
    );
  }

  apiErrorNotificationHandler({required error}) {
    if (error is dio.DioException) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
        Future.delayed(Duration(seconds: 1)).then((value) {
          Get.snackbar(
            "",
            error.response?.data.containsKey("message") == true
                ? error.response?.data['message'] ??
                      error.requestOptions.data["message"] ??
                      'Something went wrong, please try again later'
                : 'Something went wrong, please try again later',
            snackPosition: SnackPosition.TOP,
            titleText: const SizedBox(),
            isDismissible: true,
            colorText: appColors.whiteColor,
            backgroundColor: appColors.errorColor,
            margin: EdgeInsets.all(appSize.size16.sp),
          );
        });
      } else {
        Get.snackbar(
          "",
          error.response?.data.containsKey("message") == true
              ? error.response?.data['message'] ??
                    error.requestOptions.data["message"] ??
                    'Something went wrong, please try again later'
              : 'Something went wrong, please try again later',
          snackPosition: SnackPosition.TOP,
          titleText: const SizedBox(),
          isDismissible: true,
          colorText: appColors.whiteColor,
          backgroundColor: appColors.errorColor,
          margin: EdgeInsets.all(appSize.size16.sp),
        );
      }
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
        Future.delayed(Duration(seconds: 1)).then((value) {
          Get.snackbar(
            "",
            'Something went wrong, please try again later',
            snackPosition: SnackPosition.TOP,
            titleText: const SizedBox(),
            isDismissible: true,
            colorText: appColors.whiteColor,
            backgroundColor: appColors.errorColor,
            margin: EdgeInsets.all(appSize.size16.sp),
          );
        });
      } else {
        Get.snackbar(
          "",
          'Something went wrong, please try again later',
          snackPosition: SnackPosition.TOP,
          titleText: const SizedBox(),
          isDismissible: true,
          colorText: appColors.whiteColor,
          backgroundColor: appColors.errorColor,
          margin: EdgeInsets.all(appSize.size16.sp),
        );
      }
    }
  }
}

enum NotificationType { success, warning, error }
