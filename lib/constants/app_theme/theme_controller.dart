// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:yes_service_app/main.dart';
//
// import '../shared_data_key/shared_data_key.dart';
//
// class ThemeController extends GetxController {
//   Rx<ThemeMode> themeMode = ThemeMode.system.obs;
//
//   @override
//   void onInit() async {
//     super.onInit();
//     String? savedTheme = await sharedDataHandler.getSharedData(
//       key: SharedPreferenceKey.theme,
//     );
//     if (savedTheme != "") {
//       themeMode.value = ThemeMode.values.firstWhere(
//         (e) => e.toString() == savedTheme,
//       );
//     }
//   }
//
//   void toggleTheme() {
//     if (themeMode.value == ThemeMode.light) {
//       themeMode.value = ThemeMode.dark;
//     } else {
//       themeMode.value = ThemeMode.light;
//     }
//   }
// }
