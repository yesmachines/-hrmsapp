import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';

import '../controller/controller.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashScreenController());
    return Scaffold(
      body: Container(
        width: screenUtil.screenWidth,
        height: screenUtil.screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [appColors.brandColor, appColors.lightBrandColor],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -screenUtil.screenWidth * 0.35,
              left: -screenUtil.screenWidth * 0.35,
              child: Container(
                width: screenUtil.screenWidth * 1.15,
                height: screenUtil.screenWidth * 1.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: appColors.whiteColor.withValues(alpha: 0.18),
                    width: appSize.size2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -screenUtil.screenWidth * 0.45,
              right: -screenUtil.screenWidth * 0.4,
              child: Container(
                width: screenUtil.screenWidth * 1.15,
                height: screenUtil.screenWidth * 1.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: appColors.whiteColor.withValues(alpha: 0.18),
                    width: appSize.size2,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('HR App', style: fontStyles.font40White700),
                  SizedBox(height: appSize.size8),
                  Text(
                    'SMART APP MANAGEMENT',
                    style: fontStyles.font12White400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
