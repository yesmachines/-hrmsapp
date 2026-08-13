import 'package:get/get.dart';

import '../../../../constants/shared_data_key/shared_data_key.dart';
import '../../../../main.dart';

class SplashScreenController extends GetxController with Bindings {
  @override
  void onInit() {
    print("its in here");
    tokenChecking();
    super.onInit();
  }

  Future<void> tokenChecking() async {
    print("its in here");
    String token = await sharedDataHandler.getSharedData(
      key: SharedDataKey.token,
    );
    print("its in here");
    Future.delayed(Duration(seconds: 2)).then((value) async {
      if (token != "") {
        Get.offAllNamed(appRoutes.employeeDashboardView);
      } else {
        Get.offAllNamed(appRoutes.loginScreen);
      }
    });
  }

  @override
  void dependencies() {
    Get.put(SplashScreenController());
  }
}
