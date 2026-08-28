import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/assets/assets_listing_screen/service/model/asset_model.dart';

class AssetDetailsController extends GetxController with Bindings {
  late final AssetModel asset;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is AssetModel) {
      asset = args;
    } else {
      asset = AssetModel(
        id: '0',
        name: 'Unknown Asset',
        series: '-',
        assetId: '-',
        category: '-',
        assignedDate: DateTime.now(),
        condition: '-',
        status: AssetStatus.active,
        icon: Icons.devices_other_rounded,
      );
    }
    super.onInit();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  void onViewAcknowledgment() {
    notificationHandler.sendNotification(
      message: 'Opening ${asset.acknowledgmentName}',
      notificationType: .success,
    );
  }

  void onDownloadAcknowledgment() {
    notificationHandler.sendNotification(
      message: 'Downloading ${asset.acknowledgmentName}',
      notificationType: .success,
    );
  }

  @override
  void dependencies() {
    Get.put(AssetDetailsController());
  }
}
