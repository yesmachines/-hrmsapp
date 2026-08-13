import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import 'constants/api_routes/api_routes.dart';
import 'constants/app_routes/app_routes.dart';
import 'constants/app_theme/app_colors.dart';
import 'constants/app_theme/app_size.dart';
import 'constants/app_theme/font_styles.dart';
import 'constants/image_data/image_data.dart';
import 'constants/variables/variables.dart';
import 'utils/flutter_toast/flutter_toast.dart';
import 'utils/middleware/shared_data_handler/shared_data_handler.dart';
import 'utils/validations/app_validations.dart';
import 'view/common_screen/splash_screen/view/splash_screen_view.dart';

final AppRoutes appRoutes = AppRoutes();
final ApiRoutes apiRoutes = ApiRoutes();
final SharedDataHandler sharedDataHandler = SharedDataHandler();
final FontStyles fontStyles = FontStyles();
final AppColors appColors = AppColors();
final AppSize appSize = AppSize();
final ImageData imageData = ImageData();
final IconsData iconData = IconsData();
final OtherData otherData = OtherData();
final ScreenUtil screenUtil = ScreenUtil();
final NotificationHandler notificationHandler = NotificationHandler();
final AppVariables appVariables = AppVariables();
final AppValidations appValidations = AppValidations();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size.shortestSide >= 600
          ? Size(960, 1340)
          : Size(402, 874),
      builder: (context, child) {
        return KeyboardDismissOnTap(
          child: GetMaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: appColors.whiteColor,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              appBarTheme: AppBarTheme(
                backgroundColor: appColors.whiteColor,
                surfaceTintColor: Colors.transparent,
              ),
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: appColors.brandColor,
                cursorColor: appColors.brandColor,
                selectionHandleColor: appColors.brandColor,
              ),
            ),
            debugShowCheckedModeBanner: false,
            getPages: routes,
            // initialRoute: appRoutes.splashScreen,
            home: UpgradeAlert(child: SplashScreenView()),
          ),
        );
      },
    );
  }
}
