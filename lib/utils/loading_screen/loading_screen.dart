import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';

void loadingScreen({Color? loaderColor}) {
  Get.dialog(
    LoadingScreen(loaderColor: loaderColor),
    barrierDismissible: false,
  );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, this.loaderColor});

  final Color? loaderColor;

  @override
   Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: loaderColor ?? appColors.brandColor,
      ),
    );
  }
}
