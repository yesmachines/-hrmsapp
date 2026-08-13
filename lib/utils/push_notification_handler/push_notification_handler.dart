// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:yes_service_app/main.dart';
//
// import '../../constants/shared_data_key/shared_data_key.dart';
// import '../../view/authentication/login_screen/service/model/login_model.dart';
//
// handleNotification(OSNotificationClickEvent event) {
//   if (event.notification.additionalData != null) {
//     sharedDataHandler.getSharedData(key: SharedDataKey.role).then((value) {
//       if (UserTypeExtension.fromString(value) == UserType.coordinator) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Future.delayed(Duration(seconds: 3)).then((value) {
//             Get.toNamed(
//               appRoutes.jobDetailScreen,
//               arguments: event.notification.additionalData?["job_id"] ?? "",
//             );
//           });
//         });
//       } else {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Future.delayed(Duration(seconds: 3)).then((value) {
//             Get.toNamed(
//               appRoutes.technicianJobDetailView,
//               arguments: event.notification.additionalData?["job_id"] ?? "",
//             );
//           });
//         });
//       }
//     });
//   }
// }
