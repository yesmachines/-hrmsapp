import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/constants/shared_data_key/shared_data_key.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';

import '../service/service.dart';

class LoginController extends GetxController with Bindings {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.model;
    }

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.name;
    }

    return 'Unknown Device';
  }

  void onSignIn() async {
    String? isEmailValid = appValidations.validateEmail(emailController.text);
    if (isEmailValid == null && passwordController.text.isNotEmpty) {
      loadingScreen();
      String device = await getDeviceName();
      LoginService.signIn(
            email: emailController.text,
            password: passwordController.text,
            device: device,
          )
          .then((value) {
            sharedDataHandler.setSharedData(
              key: SharedDataKey.token,
              value: value.token,
            );
            sharedDataHandler.setSharedData(
              key: SharedDataKey.userId,
              value: value.userId,
            );
            Get.back();
            Get.offAllNamed(appRoutes.employeeDashboardView);
            notificationHandler.sendNotification(
              message: "Login Successful",
              notificationType: .success,
            );
          })
          .onError((error, stackTrace) {
            Get.back();
            notificationHandler.apiErrorNotificationHandler(error: error);
          });
    } else {
      if (isEmailValid != null) {
        notificationHandler.sendNotification(
          message: isEmailValid,
          notificationType: .error,
        );
      } else {
        notificationHandler.sendNotification(
          message: "Fill in your password to continue",
          notificationType: .error,
        );
      }
    }
  }

  @override
  void dependencies() {
    Get.put(LoginController());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
